//
//  HUDDrawingOverlay.mm
//  Sapphire
//
//  王者荣耀绘制覆盖层 - 完整移植自单机游戏绘制源码
//  将所有Canvas绘制函数转换为Core Graphics实现
//

#import "HUDDrawingOverlay.h"
#import <QuartzCore/QuartzCore.h>

@interface HUDDrawingOverlay ()
{
    CADisplayLink *_displayLink;
    CGFloat _scale;           // 屏幕缩放 (devicePixelRatio)
    
    // 内存读取缓存（避免频繁重复读取）
    NSMutableDictionary *_imageCache;
    
    // 团队标识
    int _teamSign;
    
    // 标签计数
    int _labelCounter;
}
@end

@implementation HUDDrawingOverlay

#pragma mark - 初始化

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self commonInit];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self commonInit];
    }
    return self;
}

- (void)commonInit {
    self.backgroundColor = [UIColor clearColor];
    self.userInteractionEnabled = NO;
    self.opaque = NO;
    self.clipsToBounds = NO;
    
    _scale = [UIScreen mainScreen].nativeScale;
    
    _screenWidth = [UIScreen mainScreen].bounds.size.width;
    _screenHeight = [UIScreen mainScreen].bounds.size.height;
    
    // 默认值
    _mapX = 32;
    _mapY = 2;
    _mapSize = 123;
    _skillX = 11;
    _skillY = 27;
    
    _isDrawEnabled = YES;
    _isLineEnabled = NO;
    _isBoxEnabled = YES;
    _isAvatarEnabled = YES;
    _isMapEnabled = YES;
    _isSkillEnabled = YES;
    _isMonsterEnabled = YES;
    
    _imageCache = [NSMutableDictionary dictionary];
    
    [self loadSettings];
}

#pragma mark - 生命周期

- (void)startDrawing {
    if (_displayLink) {
        [_displayLink invalidate];
        _displayLink = nil;
    }
    
    _displayLink = [CADisplayLink displayLinkWithTarget:self selector:@selector(renderFrame)];
    _displayLink.preferredFramesPerSecond = 20; // 与原代码50ms间隔接近
    [_displayLink addToRunLoop:[NSRunLoop mainRunLoop] forMode:NSRunLoopCommonModes];
}

- (void)stopDrawing {
    if (_displayLink) {
        [_displayLink invalidate];
        _displayLink = nil;
    }
    [self setNeedsDisplay];
}

- (void)renderFrame {
    [self setNeedsDisplay];
}

#pragma mark - 设置持久化 (替代localStorage)

- (void)loadSettings {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    id val;
    val = [defaults objectForKey:@"HUD_mapX"];
    if (val) _mapX = [val floatValue];
    
    val = [defaults objectForKey:@"HUD_mapY"];
    if (val) _mapY = [val floatValue];
    
    val = [defaults objectForKey:@"HUD_mapSize"];
    if (val) _mapSize = [val floatValue];
    
    val = [defaults objectForKey:@"HUD_skillX"];
    if (val) _skillX = [val floatValue];
    
    val = [defaults objectForKey:@"HUD_skillY"];
    if (val) _skillY = [val floatValue];
    
    val = [defaults objectForKey:@"HUD_isDrawEnabled"];
    if (val) _isDrawEnabled = [val boolValue];
    
    val = [defaults objectForKey:@"HUD_isLineEnabled"];
    if (val) _isLineEnabled = [val boolValue];
    
    val = [defaults objectForKey:@"HUD_isBoxEnabled"];
    if (val) _isBoxEnabled = [val boolValue];
    
    val = [defaults objectForKey:@"HUD_isAvatarEnabled"];
    if (val) _isAvatarEnabled = [val boolValue];
    
    val = [defaults objectForKey:@"HUD_isMapEnabled"];
    if (val) _isMapEnabled = [val boolValue];
    
    val = [defaults objectForKey:@"HUD_isSkillEnabled"];
    if (val) _isSkillEnabled = [val boolValue];
    
    val = [defaults objectForKey:@"HUD_isMonsterEnabled"];
    if (val) _isMonsterEnabled = [val boolValue];
}

- (void)saveSettings {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    [defaults setFloat:_mapX forKey:@"HUD_mapX"];
    [defaults setFloat:_mapY forKey:@"HUD_mapY"];
    [defaults setFloat:_mapSize forKey:@"HUD_mapSize"];
    [defaults setFloat:_skillX forKey:@"HUD_skillX"];
    [defaults setFloat:_skillY forKey:@"HUD_skillY"];
    [defaults setBool:_isDrawEnabled forKey:@"HUD_isDrawEnabled"];
    [defaults setBool:_isLineEnabled forKey:@"HUD_isLineEnabled"];
    [defaults setBool:_isBoxEnabled forKey:@"HUD_isBoxEnabled"];
    [defaults setBool:_isAvatarEnabled forKey:@"HUD_isAvatarEnabled"];
    [defaults setBool:_isMapEnabled forKey:@"HUD_isMapEnabled"];
    [defaults setBool:_isSkillEnabled forKey:@"HUD_isSkillEnabled"];
    [defaults setBool:_isMonsterEnabled forKey:@"HUD_isMonsterEnabled"];
    
    [defaults synchronize];
}

#pragma mark - Core Graphics 绘制 (主渲染入口)

- (void)drawRect:(CGRect)rect {
    [super drawRect:rect];
    
    if (!_isDrawEnabled || !_memoryUtils || !_memoryUtils.isValid) return;
    
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    if (!ctx) return;
    
    // 清除画布
    CGContextClearRect(ctx, rect);
    
    [self shadowDrawWithContext:ctx];
}

#pragma mark - 主绘制逻辑 (移植自 shadowDraw)

- (void)shadowDrawWithContext:(CGContextRef)ctx {
    if (!_memoryUtils || !_memoryUtils.isValid) return;
    if (_baseAddr == 0) return;
    
    NSError *error = nil;
    
    // === 读取GWorld ===
    uint64_t GWorld = [self readPtr:_baseAddr + 0x1338ED90];
    if ([self isInvalidPtr:GWorld]) return;
    
    // === 读取Level ===
    uint64_t Level = [self readPtr:GWorld + 0x138];
    if ([self isInvalidPtr:Level]) return;
    
    // === 读取Actor数组 ===
    uint64_t ActorArray = [self readPtr:Level + 0x60];
    if ([self isInvalidPtr:ActorArray]) return;
    
    int ActorCount = (int)[_memoryUtils readInt32AtAddress:Level + 0x7C error:&error];
    if (error || ActorCount <= 0) return;
    
    // === 读取矩阵 ===
    uint64_t juzhen = [self readPtr:[self readPtr:[self readPtr:_baseAddr + 0x12DFB130] + 0xB8] + 0x0];
    if ([self isInvalidPtr:juzhen]) return;
    juzhen = [self readPtr:juzhen + 0x8];
    if ([self isInvalidPtr:juzhen]) return;
    
    // 读取16个矩阵浮点数
    CGFloat Matrix[16];
    for (int i = 0; i < 16; i++) {
        float val = [_memoryUtils readFloatAtAddress:juzhen + 0x128 + i * 0x4 error:&error];
        Matrix[i] = val;
        if (error) return;
    }
    
    // === 判断阵营 ===
    int myTeam = Matrix[0] > 0 ? 1 : 2;
    int teamSign = (myTeam == 1) ? -1 : 1;
    _teamSign = teamSign;
    
    // === 标签计数器 ===
    int biaoshi[] = {1, 3, 5, 7, 9, 11};
    _labelCounter = 0;
    
    // === 遍历Actor ===
    for (int i = 0; i < ActorCount; i++) {
        uint64_t actor = [self readPtr:ActorArray + i * 0x18];
        if ([self isInvalidPtr:actor]) continue;
        
        // === 读取阵营 ===
        int zhenying = (int)[_memoryUtils readInt32AtAddress:actor + 0x5C error:&error];
        if (error) continue;
        if (zhenying == myTeam) continue;
        
        // === 读取英雄ID ===
        uint64_t heroId = [self readPtr:actor + 0x50];
        if ([self isInvalidPtr:heroId]) continue;
        
        // === 标签位置 ===
        int labelIndex = (_labelCounter < 6) ? biaoshi[_labelCounter] : 11;
        CGFloat skillLabelX = 167 + labelIndex * 13;
        _labelCounter++;
        
        // === 读取HP ===
        uint64_t hpAddr = [self readPtr:actor + 0x188];
        if ([self isInvalidPtr:hpAddr]) continue;
        
        int hp = (int)[_memoryUtils readInt32AtAddress:hpAddr + 0xA8 error:&error];
        if (error || hp == 0) continue;
        
        int hpMax = (int)[_memoryUtils readInt32AtAddress:hpAddr + 0xB0 error:&error];
        if (error) continue;
        CGFloat hpPercent = 100.0 * hp / hpMax;
        
        // === 读取召唤师技能 ===
        uint64_t skillBlock = [self readPtr:actor + 0x170];
        if ([self isInvalidPtr:skillBlock]) continue;
        
        // 大招时间
        uint64_t ultBlock = [self readPtr:skillBlock + 0x108];
        int ultTime = 0;
        if (![self isInvalidPtr:ultBlock]) {
            uint64_t ultData = [self readPtr:ultBlock + 0xf8];
            if (![self isInvalidPtr:ultData]) {
                int rawUlt = (int)[_memoryUtils readInt32AtAddress:ultData + 0x3C error:&error];
                if (!error) ultTime = floor(rawUlt / 8192000.0);
            }
        }
        
        // 召唤师技能时间
        uint64_t summonBlock = [self readPtr:skillBlock + 0x150];
        int summonTime = 0;
        int summonId = 0;
        if (![self isInvalidPtr:summonBlock]) {
            uint64_t summonData = [self readPtr:summonBlock + 0xf8];
            if (![self isInvalidPtr:summonData]) {
                int rawSummon = (int)[_memoryUtils readInt32AtAddress:summonData + 0x3C error:&error];
                if (!error) summonTime = floor(rawSummon / 8192000.0);
                summonId = (int)[_memoryUtils readInt32AtAddress:summonBlock + 0x3A8 error:&error];
            }
        }
        
        // === 读取世界坐标 ===
        uint64_t coordBlock = [self readPtr:actor + 0x268];
        if ([self isInvalidPtr:coordBlock]) continue;
        
        uint64_t coordPtr = [self readPtr:[self readPtr:[self readPtr:coordBlock + 0x10] + 0x0] + 0x60];
        if ([self isInvalidPtr:coordPtr]) continue;
        
        CGFloat worldX = [_memoryUtils readFloatAtAddress:coordPtr + 0x0 error:&error];
        if (error) continue;
        CGFloat worldY = [_memoryUtils readFloatAtAddress:coordPtr + 0x8 error:&error];
        if (error) continue;
        
        // 判断假坐标
        if (worldX == 1000000) continue;
        
        // === 读取回城状态 ===
        int huicheng = 0;
        uint64_t recallBlock = [self readPtr:skillBlock + 0x168];
        if (![self isInvalidPtr:recallBlock]) {
            uint64_t recallData = [self readPtr:recallBlock + 0x110];
            if (![self isInvalidPtr:recallData]) {
                huicheng = (int)[_memoryUtils readInt32AtAddress:recallData - 0x128 error:&error];
            }
        }
        
        // === 计算小地图坐标 (0x1A9C8) ===
        CGFloat minimapX = worldX * teamSign / 0x1A9C8 * _mapSize * 1.0 + _mapX + _mapSize * 0.5;
        CGFloat minimapY = worldY * teamSign / 0x1A9C8 * _mapSize * -1.0 + _mapY + _mapSize * 0.5;
        
        // === 计算大地图坐标 (屏幕投影) ===
        CGFloat b_w = Matrix[2] * (worldX / 1000.0) + Matrix[10] * (worldY / 1000.0) + Matrix[14];
        if (b_w < -100) continue;
        b_w = 1.0 / b_w;
        CGFloat screenX = (1.0 + (Matrix[0] * (worldX / 1000.0) + Matrix[8] * (worldY / 1000.0) + Matrix[12]) * b_w) * _screenWidth / 2.0;
        CGFloat screenY = (1.0 - (Matrix[1] * (worldX / 1000.0) + Matrix[9] * (worldY / 1000.0) + Matrix[13]) * b_w) * _screenHeight / 2.0;
        
        // === 技能绘制 ===
        if (_isSkillEnabled) {
            CGFloat skillDrawX = skillLabelX - 20 + _skillX;
            CGFloat skillDrawY = 3 + _skillY;
            
            // 绘制英雄头像
            NSString *heroImgUrl = [NSString stringWithFormat:@"https://game.gtimg.cn/images/yxzj/img201606/heroimg/%llu/%llu.jpg", heroId, heroId];
            UIImage *heroImage = [self cachedImageFromURL:heroImgUrl];
            if (heroImage) {
                [self drawCircleImage:heroImage atX:skillDrawX y:skillDrawY width:24 height:24 inContext:ctx];
            }
            
            // 绘制召唤师技能图标
            NSString *summonImgUrl = [NSString stringWithFormat:@"https://game.gtimg.cn/images/yxzj/img201606/summonero/%d.png", summonId];
            UIImage *summonImage = [self cachedImageFromURL:summonImgUrl];
            if (summonImage) {
                [self drawCircleImage:summonImage atX:skillDrawX y:30 + _skillY width:24 height:24 inContext:ctx];
            }
            
            // 召唤师技能时间
            if (summonTime > 0) {
                [self drawText:[NSString stringWithFormat:@"%d", summonTime]
                            x:skillDrawX + 12 y:32 + _skillY size:10 color:[UIColor whiteColor] fill:YES inContext:ctx];
                [self drawCircularProgressAtX:skillDrawX + 12 y:42 + _skillY
                                    progress:summonTime maxProgress:100
                                    radius:11 color:[UIColor whiteColor] lineWidth:6 inContext:ctx];
            }
            
            // 大招时间
            if (ultTime > 0) {
                [self drawText:[NSString stringWithFormat:@"%d", ultTime]
                            x:skillDrawX + 12 y:_skillY + 5 size:10 color:[UIColor yellowColor] fill:YES inContext:ctx];
                [self drawCircularProgressAtX:skillDrawX + 12 y:15 + _skillY
                                    progress:ultTime maxProgress:100
                                    radius:11 color:[UIColor whiteColor] lineWidth:6 inContext:ctx];
            }
        }
        
        // === 射线绘制 ===
        if (_isLineEnabled) {
            [self drawLineFromX:_screenWidth / 2.0 y1:_screenHeight / 2.0
                             x2:screenX y2:screenY - 6
                          color:[UIColor yellowColor] inContext:ctx];
            // 百里打击点
            [self drawCircleAtX:screenX y:screenY - 6 radius:4 color:[UIColor redColor] fill:YES inContext:ctx];
        }
        
        // === 小地图绘制 ===
        if (_isMapEnabled) {
            // 小地图边框
            [self drawRectAtX:_mapX y:_mapY width:_mapSize height:_mapSize
                       color:[UIColor yellowColor] fill:NO inContext:ctx];
            
            // 小地图头像
            NSString *heroImgUrl2 = [NSString stringWithFormat:@"https://game.gtimg.cn/images/yxzj/img201606/heroimg/%llu/%llu.jpg", heroId, heroId];
            UIImage *heroImage2 = [self cachedImageFromURL:heroImgUrl2];
            if (heroImage2) {
                [self drawCircleImage:heroImage2 atX:minimapX - 8 y:minimapY - 8 width:16 height:16 inContext:ctx];
            }
            
            // 小地图血条
            [self drawCircularProgressAtX:minimapX y:minimapY
                                progress:hpPercent maxProgress:100
                                radius:8 color:[UIColor greenColor] lineWidth:7 inContext:ctx];
            
            // 回城文字
            if (huicheng == 1) {
                [self drawText:@"回城" x:minimapX y:minimapY - 6 size:8
                         color:[UIColor yellowColor] fill:YES inContext:ctx];
            }
        }
        
        // === 屏幕外剔除 ===
        if (screenX < 0 || screenY < 0 || screenX > _screenWidth || screenY > _screenHeight) continue;
        
        // === 大地图方框 ===
        if (_isBoxEnabled) {
            [self drawMyRectAtX:screenX - 20 y:screenY - 50 width:40 height:60
                      lineWidth:2 color:[UIColor cyanColor] inContext:ctx];
        }
        
        // === 头像 ===
        if (_isAvatarEnabled) {
            NSString *heroImgUrl3 = [NSString stringWithFormat:@"https://game.gtimg.cn/images/yxzj/img201606/heroimg/%llu/%llu.jpg", heroId, heroId];
            UIImage *heroImage3 = [self cachedImageFromURL:heroImgUrl3];
            if (heroImage3) {
                [self drawCircleImage:heroImage3 atX:screenX - 8 y:screenY - 60 width:16 height:16 inContext:ctx];
            }
        }
    }
    
    // === 野怪绘制 ===
    if (_isMonsterEnabled && ActorCount == 10) {
        uint64_t monsterArray = [self readPtr:[self readPtr:[self readPtr:_baseAddr + 0x12947DD0] + 0x3B8] + 0x88];
        if (![self isInvalidPtr:monsterArray]) {
            monsterArray = [self readPtr:monsterArray + 0x140];
            if (![self isInvalidPtr:monsterArray]) {
                [self drawMonstersWithContext:ctx monsterArray:monsterArray];
            }
        }
    }
}

#pragma mark - 野怪绘制

- (void)drawMonstersWithContext:(CGContextRef)ctx monsterArray:(uint64_t)monsterArray {
    NSError *error = nil;
    
    for (int r = 0; r < 20; r++) {
        uint64_t monster = [self readPtr:monsterArray + r * 0x18];
        if ([self isInvalidPtr:monster]) continue;
        
        // int monsterId = (int)[_memoryUtils readInt32AtAddress:monster + 0xC0 error:&error];
        // 已读取但当前未使用怪物类型ID，保留供后续扩展
        int _unused_monsterId = (int)[_memoryUtils readInt32AtAddress:monster + 0xC0 error:&error];
        (void)_unused_monsterId;
        if (error) continue;
        
        int rawTime = (int)[_memoryUtils readInt32AtAddress:monster + 0x240 error:&error];
        if (error) continue;
        CGFloat time = rawTime / 1000.0 + 3;
        
        int rawTimeMax = (int)[_memoryUtils readInt32AtAddress:monster + 0x1E4 error:&error];
        if (error) continue;
        CGFloat timeMax = rawTimeMax / 1000.0 + 3;
        
        CGFloat monsterPosX = [_memoryUtils readFloatAtAddress:monster + 0x2B8 error:&error];
        if (error) continue;
        CGFloat monsterPosY = [_memoryUtils readFloatAtAddress:monster + 0x2C0 error:&error];
        if (error) continue;
        
        CGFloat x = monsterPosX * _teamSign / 0x186a0 * _mapSize * 1.0 + _mapX + _mapSize * 0.5;
        CGFloat y = monsterPosY * _teamSign / 0x186a0 * _mapSize * -1.0 + _mapY + _mapSize * 0.5;
        
        if (fabs(time - timeMax) < 0.01) {
            // 野怪存活 - 画绿点
            [self drawCircleAtX:x y:y radius:2 color:[UIColor greenColor] fill:YES inContext:ctx];
        } else {
            // 野怪刷新倒计时
            [self drawText:[NSString stringWithFormat:@"%.0f", ceil(time)]
                         x:x y:y - 10 size:8 color:[UIColor whiteColor] fill:YES inContext:ctx];
        }
    }
}

#pragma mark - 内存读取辅助 (移植自 readInt/readLong/readFloat)

- (uint64_t)readPtr:(uint64_t)addr {
    if (addr == 0) return 0;
    NSError *error = nil;
    uint64_t val = [_memoryUtils readUInt64AtAddress:addr error:&error];
    if (error) return 0;
    return val;
}

- (BOOL)isInvalidPtr:(uint64_t)addr {
    return (addr < 0x100000000 || addr > 0x300000000);
}

#pragma mark - 图片缓存

- (UIImage *)cachedImageFromURL:(NSString *)urlString {
    if (!urlString) return nil;
    
    UIImage *cached = _imageCache[urlString];
    if (cached) return cached;
    
    // 限制缓存大小
    if (_imageCache.count > 60) {
        [_imageCache removeAllObjects];
    }
    
    // 同步加载图片（异步会导致绘制延迟）
    NSURL *url = [NSURL URLWithString:urlString];
    if (!url) return nil;
    
    NSData *data = [NSData dataWithContentsOfURL:url options:NSDataReadingMappedAlways error:nil];
    if (!data) return nil;
    
    UIImage *image = [UIImage imageWithData:data];
    if (image) {
        _imageCache[urlString] = image;
    }
    return image;
}

#pragma mark - ============ 绘制函数 (移植自Canvas) ============

#pragma mark - 绘制圆形图片

- (void)drawCircleImage:(UIImage *)img atX:(CGFloat)x y:(CGFloat)y width:(CGFloat)w height:(CGFloat)h inContext:(CGContextRef)ctx {
    CGFloat scaledX = x * _scale;
    CGFloat scaledY = y * _scale;
    CGFloat scaledW = w * _scale;
    CGFloat scaledH = h * _scale;
    
    CGContextSaveGState(ctx);
    CGContextSetAlpha(ctx, 1.0);
    
    // 圆形裁剪
    UIBezierPath *clipPath = [UIBezierPath bezierPathWithOvalInRect:CGRectMake(scaledX, scaledY, scaledW, scaledH)];
    [clipPath addClip];
    
    [img drawInRect:CGRectMake(scaledX, scaledY, scaledW, scaledH)];
    
    CGContextRestoreGState(ctx);
}

#pragma mark - 绘制圆形

- (void)drawCircleAtX:(CGFloat)x y:(CGFloat)y radius:(CGFloat)r color:(UIColor *)color fill:(BOOL)isFill inContext:(CGContextRef)ctx {
    CGFloat scaledX = x * _scale;
    CGFloat scaledY = y * _scale;
    CGFloat scaledR = r * _scale;
    
    CGContextBeginPath(ctx);
    CGContextSetStrokeColorWithColor(ctx, color.CGColor);
    CGContextSetFillColorWithColor(ctx, color.CGColor);
    CGContextAddArc(ctx, scaledX, scaledY, scaledR, 0, 2 * M_PI, 0);
    
    if (isFill) {
        CGContextFillPath(ctx);
    } else {
        CGContextStrokePath(ctx);
    }
    CGContextClosePath(ctx);
}

#pragma mark - 绘制圆形进度条 (圆形血条、技能CD)

- (void)drawCircularProgressAtX:(CGFloat)x y:(CGFloat)y
                       progress:(CGFloat)progress maxProgress:(CGFloat)maxProgress
                         radius:(CGFloat)radius color:(UIColor *)color
                      lineWidth:(CGFloat)lineWidth inContext:(CGContextRef)ctx {
    
    CGFloat scaledX = x * _scale;
    CGFloat scaledY = y * _scale;
    CGFloat scaledR = radius * _scale;
    CGFloat scaledLineWidth = lineWidth;
    
    if (progress >= maxProgress) progress = maxProgress;
    CGFloat percentage = progress / maxProgress;
    if (percentage > 1.0) percentage = 1.0;
    
    CGFloat startAngle = -M_PI_2; // -90度 (顶部开始)
    CGFloat endAngle = startAngle + (percentage * 2 * M_PI);
    
    CGContextBeginPath(ctx);
    CGContextSetLineWidth(ctx, scaledLineWidth);
    CGContextSetStrokeColorWithColor(ctx, color.CGColor);
    CGContextSetFillColorWithColor(ctx, color.CGColor);
    CGContextAddArc(ctx, scaledX, scaledY, scaledR, startAngle, endAngle, false);
    CGContextStrokePath(ctx);
    CGContextClosePath(ctx);
}

#pragma mark - 绘制线条

- (void)drawLineFromX:(CGFloat)x1 y1:(CGFloat)y1 x2:(CGFloat)x2 y2:(CGFloat)y2
                color:(UIColor *)color inContext:(CGContextRef)ctx {
    
    CGFloat sX1 = x1 * _scale;
    CGFloat sY1 = y1 * _scale;
    CGFloat sX2 = x2 * _scale;
    CGFloat sY2 = y2 * _scale;
    
    CGContextBeginPath(ctx);
    CGContextSetStrokeColorWithColor(ctx, color.CGColor);
    CGContextSetFillColorWithColor(ctx, color.CGColor);
    CGContextSetLineWidth(ctx, 2);
    CGContextMoveToPoint(ctx, sX1, sY1);
    CGContextAddLineToPoint(ctx, sX2, sY2);
    CGContextStrokePath(ctx);
    CGContextClosePath(ctx);
}

#pragma mark - 绘制矩形

- (void)drawRectAtX:(CGFloat)x y:(CGFloat)y width:(CGFloat)w height:(CGFloat)h
              color:(UIColor *)color fill:(BOOL)isFill inContext:(CGContextRef)ctx {
    
    CGFloat sX = x * _scale;
    CGFloat sY = y * _scale;
    CGFloat sW = w * _scale;
    CGFloat sH = h * _scale;
    
    CGContextBeginPath(ctx);
    CGContextSetStrokeColorWithColor(ctx, color.CGColor);
    CGContextSetFillColorWithColor(ctx, color.CGColor);
    CGContextSetLineWidth(ctx, 2);
    CGContextSetAlpha(ctx, 1.0);
    
    if (isFill) {
        CGContextFillRect(ctx, CGRectMake(sX, sY, sW, sH));
    } else {
        CGContextStrokeRect(ctx, CGRectMake(sX, sY, sW, sH));
    }
    CGContextClosePath(ctx);
}

#pragma mark - 绘制带拐角的方框 (移植自 drawMyRect)

- (void)drawMyRectAtX:(CGFloat)x y:(CGFloat)y width:(CGFloat)width height:(CGFloat)height
            lineWidth:(CGFloat)lineWidth color:(UIColor *)color inContext:(CGContextRef)ctx {
    
    CGFloat sX = x * _scale;
    CGFloat sY = y * _scale;
    CGFloat sW = width * _scale;
    CGFloat sH = height * _scale;
    CGFloat sLW = lineWidth;
    
    CGContextSetLineWidth(ctx, sLW);
    CGContextSetStrokeColorWithColor(ctx, color.CGColor);
    CGContextSetAlpha(ctx, 1.0);
    CGContextBeginPath(ctx);
    
    // 左上角
    CGContextMoveToPoint(ctx, sX, sY);
    CGContextAddLineToPoint(ctx, sX + sW / 6, sY);
    CGContextClosePath(ctx);
    
    CGContextMoveToPoint(ctx, sX, sY);
    CGContextAddLineToPoint(ctx, sX, sY + sH / 9);
    CGContextClosePath(ctx);
    
    // 右上角
    CGContextMoveToPoint(ctx, sX + sW - sW / 6, sY);
    CGContextAddLineToPoint(ctx, sX + sW, sY);
    CGContextClosePath(ctx);
    
    CGContextMoveToPoint(ctx, sX + sW, sY);
    CGContextAddLineToPoint(ctx, sX + sW, sY + sH / 9);
    CGContextClosePath(ctx);
    
    // 左下角
    CGContextMoveToPoint(ctx, sX, sY + sH);
    CGContextAddLineToPoint(ctx, sX, sY + sH - sH / 9);
    CGContextClosePath(ctx);
    
    CGContextMoveToPoint(ctx, sX, sY + sH);
    CGContextAddLineToPoint(ctx, sX + sW / 6, sY + sH);
    CGContextClosePath(ctx);
    
    // 右下角
    CGContextMoveToPoint(ctx, sX + sW, sY + sH);
    CGContextAddLineToPoint(ctx, sX + sW - sW / 6, sY + sH);
    CGContextClosePath(ctx);
    
    CGContextMoveToPoint(ctx, sX + sW, sY + sH);
    CGContextAddLineToPoint(ctx, sX + sW, sY + sH - sH / 9);
    CGContextClosePath(ctx);
    
    CGContextStrokePath(ctx);
}

#pragma mark - 绘制文字

- (void)drawText:(NSString *)text x:(CGFloat)x y:(CGFloat)y size:(CGFloat)size
           color:(UIColor *)color fill:(BOOL)isFill inContext:(CGContextRef)ctx {
    
    CGFloat sX = x * _scale;
    CGFloat sY = y * _scale;
    CGFloat sSize = size * _scale;
    
    UIGraphicsPushContext(ctx);
    
    NSMutableParagraphStyle *style = [[NSMutableParagraphStyle alloc] init];
    style.alignment = NSTextAlignmentCenter;
    
    NSDictionary *attrs = @{
        NSFontAttributeName: [UIFont systemFontOfSize:sSize],
        NSForegroundColorAttributeName: color,
        NSParagraphStyleAttributeName: style
    };
    
    CGSize textSize = [text sizeWithAttributes:attrs];
    CGRect textRect = CGRectMake(sX - textSize.width / 2.0,
                                  sY + sSize - textSize.height,
                                  textSize.width, textSize.height);
    
    if (isFill) {
        [text drawInRect:textRect withAttributes:attrs];
    } else {
        // 描边效果 - 用背景色填充绘制描边文字
        CGContextSetTextDrawingMode(ctx, kCGTextFillStroke);
        [text drawInRect:textRect withAttributes:attrs];
    }
    
    UIGraphicsPopContext();
}

#pragma mark - 绘制三角形

- (void)drawTriangleX1:(CGFloat)x1 y1:(CGFloat)y1
                    x2:(CGFloat)x2 y2:(CGFloat)y2
                    x3:(CGFloat)x3 y3:(CGFloat)y3
                 color:(UIColor *)color alpha:(CGFloat)alpha
                  fill:(BOOL)isFill inContext:(CGContextRef)ctx {
    
    CGFloat sX1 = x1 * _scale, sY1 = y1 * _scale;
    CGFloat sX2 = x2 * _scale, sY2 = y2 * _scale;
    CGFloat sX3 = x3 * _scale, sY3 = y3 * _scale;
    
    CGContextBeginPath(ctx);
    CGContextSetStrokeColorWithColor(ctx, color.CGColor);
    CGContextSetFillColorWithColor(ctx, color.CGColor);
    CGContextSetAlpha(ctx, alpha);
    CGContextMoveToPoint(ctx, sX1, sY1);
    CGContextAddLineToPoint(ctx, sX2, sY2);
    CGContextAddLineToPoint(ctx, sX3, sY3);
    CGContextClosePath(ctx);
    
    if (isFill) {
        CGContextFillPath(ctx);
    } else {
        CGContextStrokePath(ctx);
    }
}

#pragma mark - 析构

- (void)dealloc {
    [self stopDrawing];
    [_imageCache removeAllObjects];
}

@end
