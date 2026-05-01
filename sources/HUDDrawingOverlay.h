//
//  HUDDrawingOverlay.h
//  Sapphire
//
//  王者荣耀绘制覆盖层 - 移植自单机游戏绘制源码
//

#import <UIKit/UIKit.h>
#import "Memory.h"

NS_ASSUME_NONNULL_BEGIN

@interface HUDDrawingOverlay : UIView

// === 绘制开关 ===
@property (nonatomic, assign) BOOL isDrawEnabled;      // 绘制总开关
@property (nonatomic, assign) BOOL isLineEnabled;      // 射线
@property (nonatomic, assign) BOOL isBoxEnabled;       // 方框
@property (nonatomic, assign) BOOL isAvatarEnabled;    // 头像
@property (nonatomic, assign) BOOL isMapEnabled;       // 小地图
@property (nonatomic, assign) BOOL isSkillEnabled;     // 技能
@property (nonatomic, assign) BOOL isMonsterEnabled;   // 野怪

// === 位置参数 ===
@property (nonatomic, assign) CGFloat mapX;             // 小地图X
@property (nonatomic, assign) CGFloat mapY;             // 小地图Y
@property (nonatomic, assign) CGFloat mapSize;          // 小地图大小
@property (nonatomic, assign) CGFloat skillX;           // 技能X
@property (nonatomic, assign) CGFloat skillY;           // 技能Y

// === 游戏基础地址 ===
@property (nonatomic, assign) uint64_t baseAddr;

// === 屏幕参数 ===
@property (nonatomic, assign) CGFloat screenWidth;
@property (nonatomic, assign) CGFloat screenHeight;

// === 内存工具 ===
@property (nonatomic, strong) MemoryUtils *memoryUtils;

// === 生命周期 ===
- (void)startDrawing;
- (void)stopDrawing;

// === 从NSUserDefaults加载设置 ===
- (void)loadSettings;
- (void)saveSettings;

@end

NS_ASSUME_NONNULL_END
