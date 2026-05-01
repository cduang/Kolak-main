#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
#import <CoreGraphics/CoreGraphics.h>
#import <AdSupport/AdSupport.h>
#import <CommonCrypto/CommonCrypto.h>
#include <mach-o/dyld.h>
#import <Foundation/Foundation.h>
#import <UIKit/UIControl.h>
#import "satooios.h"
#import "../UI/UIHelper.h"

// #import "Memory.h"
// #import "../Hooks/hook.h"

#import "CaptainHook.h"
#import "Vector3.h"
#import "Vector2.h"
#import "Quaternion.h"
#import "Monostring.h"
#import "Obfuscate.h"
// #import "../Hooks/Hooks.h"

// تم نقل وظائف المساعدة الأمنية والتحقق من الاتصال إلى Helper/UIHelper.mm
// تم نقل وظائف المساعدة الصوتية إلى Helper/SoundHelper.mm

// extern Vars_t Vars;
#define kWidth  [UIScreen mainScreen].bounds.size.width
#define kHeight [UIScreen mainScreen].bounds.size.height

#define menuContainer    _kNhz28MfAL9o
#define sidebarView      _PxYqLm9R7TuE
#define contentView      _Zq3uAj94kVbL
#define aimbotView       _QpWkzN7LmD9R
#define visualsView      _Yz83fLpKAd2w
#define miscView         _VqZ4TruM8xNc
#define weaponView       _x4TbL7pRtWqL
#define settingsView     _NaDk97vPq1Mf
#define currentTab       _pTrmW8ZjAo3X
#define initialTouchPoint _RqZmLp7bMc5D

#define iconEye          _IkNaKc7QWmv1
#define iconAimbot       _ZxWvLm1BoPr8
#define iconMisc         _Lt4MvNzpK1Df
#define iconWeapon       _WxP1z9KmRoAv
#define iconSettings     _KaR7XoJmTzLn
#define iconCheck        _CrZmLx9KqBp0
#define iconWarning      _BvZmNt6PoRcD
#define iconSave         _mRz81DfKwTqL
#define arrowDown        _xNg72VpOyMzR
#define iconClose        _pLm92KxNzQwR
#define iconMoon         _tWk39LmPqRxZ

#define fontRegular      _AoPvJt9ZwRmL
#define fontSemiBold     _XrTvKoMw3Bd9

#define handlePan _nWo53CxYuEwL
#define buildSidebar _vGr84NzTcLpW
#define updateContentView _wFk28MvTbYxL
#define didTapTab _mUx73KsWiAoZ

#define addSliderTo _sLp45MwXtZcV
#define withText _vEz29RnCfQoP
#define valueRef _kTu39OwMaCvX
#define min _pDz18RfWtMzL
#define max _zLq71EvBnXaS

#define addCheckboxTo _yHt92XbQeUwA
#define enabledRef _jRx83WqMzNtP
#define isWarning _lFt93QoVaNwD

#define addComboBoxTo _vLa27RhGpYqE
#define atY _qZw47BmLoPxN
#define withTitle _eNc92SdXtFwL
#define selectedIndex _bYq31LtPwMxJ
#define hasWarning _zXw61NeCoT13d

// Hack features variables removed to ensure compliance.

// Desactivo and Activo functions removed as they relate to hack features.



typedef NS_ENUM(NSUInteger, MenuTab) {
    MenuTabAimbot = 0,
    MenuTabVisuals = 1,
    MenuTabMisc    = 2,
    MenuTabSettings= 3
};

@interface Khanhios() <UIGestureRecognizerDelegate>
@property (nonatomic, strong) UIAlertView* alertView;

@property (nonatomic, strong) UIView *menuContainer;
@property (nonatomic, strong) UIView *sidebarView;
@property (nonatomic, strong) UIView *contentView;
@property (nonatomic, strong) UIView *aimbotView;
@property (nonatomic, strong) UIView *visualsView;
@property (nonatomic, strong) UIView *miscView;
@property (nonatomic, strong) UIView *settingsView;
@property (nonatomic, assign) MenuTab currentTab;
@property (nonatomic, assign) CGPoint initialTouchPoint;
@property (nonatomic, assign) float menuAlpha;
@property (nonatomic, strong) UIScrollView *sidebarScroll;
@property (nonatomic, strong) UIColor *panelAccentColor;

// Iconos y fuentes
@property (nonatomic, strong) UIImage *iconAimbot;
@property (nonatomic, strong) UIImage *iconEye;
@property (nonatomic, strong) UIImage *iconMisc;
@property (nonatomic, strong) UIImage *iconSettings;
@property (nonatomic, strong) UIImage *iconCheck;
@property (nonatomic, strong) UIImage *iconWarning;
@property (nonatomic, strong) UIImage *iconSave;
@property (nonatomic, strong) UIImage *arrowDown;
@property (nonatomic, strong) UIImage *iconClose;
@property (nonatomic, strong) UIImage *iconMoon;

@property (nonatomic, strong) UIFont *fontRegular;
@property (nonatomic, strong) UIFont *fontSemiBold;

// @property (nonatomic, strong) CADisplayLink *displayLink;
@property (nonatomic, assign) CGPoint panStartLocation;
@property (nonatomic, assign) CGPoint menuStartCenter;

// Para rastrear sliders
@property (nonatomic, strong) NSMutableArray *sliderContainers;

@end

@implementation Khanhios

static Khanhios *extraInfo;
static BOOL MenDeal;
UIWindow *mainWindow;

// Colores للسمة - Dark Blue كـ لون رئيسي (مؤشر 3)
NSArray<UIColor *> *colorValues = @[
    [UIColor colorWithRed:0.8 green:0.5 blue:1.0 alpha:1.0],   // Purple
    [UIColor colorWithRed:1.0 green:0.3 blue:0.3 alpha:1.0],   // Red
    [UIColor colorWithRed:0.3 green:1.0 blue:1.0 alpha:1.0],   // Cyan
    [UIColor colorWithRed:0.2 green:0.4 blue:1.0 alpha:1.0],   // Dark Blue - PRINCIPAL
    [UIColor colorWithRed:1.0 green:1.0 blue:0.4 alpha:1.0],   // Yellow
    [UIColor colorWithRed:0.3 green:1.0 blue:0.3 alpha:1.0],   // Green
    [UIColor colorWithRed:1.0 green:0.6 blue:0.2 alpha:1.0],   // Orange
    [UIColor colorWithRed:1.0 green:0.4 blue:0.7 alpha:1.0],   // Pink
    [UIColor colorWithRed:0.2 green:0.8 blue:0.8 alpha:1.0],   // Teal
    [UIColor colorWithRed:0.5 green:0.4 blue:0.9 alpha:1.0],   // Indigo
    [UIColor colorWithRed:0.8 green:1.0 blue:0.2 alpha:1.0],   // Lime
    [UIColor colorWithRed:0.6 green:0.4 blue:0.2 alpha:1.0],   // Brown
    [UIColor colorWithRed:0.53 green:0.81 blue:0.98 alpha:1.0], // Sky Blue
    [UIColor colorWithRed:1.0 green:0.55 blue:0.71 alpha:1.0],  // Rose
    [UIColor colorWithRed:0.9 green:0.9 blue:0.98 alpha:1.0],   // Lavender
    [UIColor colorWithRed:0.74 green:1.0 blue:0.78 alpha:1.0],  // Mint
    [UIColor colorWithRed:1.0 green:0.5 blue:0.31 alpha:1.0],   // Coral
    [UIColor colorWithRed:0.25 green:0.88 blue:0.82 alpha:1.0], // Turquoise
    [UIColor colorWithRed:1.0 green:0.84 blue:0.0 alpha:1.0],   // Gold
    [UIColor colorWithRed:0.75 green:0.75 blue:0.75 alpha:1.0], // Silver
    [UIColor colorWithRed:0.0 green:1.0 blue:0.0 alpha:1.0],    // Neon Green
    [UIColor colorWithRed:1.0 green:0.08 blue:0.58 alpha:1.0],  // Neon Pink
    [UIColor colorWithRed:0.4 green:0.0 blue:0.6 alpha:1.0],    // Deep Purple
    [UIColor colorWithRed:0.86 green:0.08 blue:0.24 alpha:1.0], // Crimson
    [UIColor colorWithRed:0.0 green:0.4 blue:1.0 alpha:1.0],    // Electric Blue
    [UIColor colorWithRed:1.0 green:0.37 blue:0.0 alpha:1.0]    // Sunset Orange
];
static int selectedColorIndex = 3; // Dark Blue كـ افتراضي

#pragma mark - Funciones de Diseño Moderno

// FUNCIÓN MODIFICADA: Ahora aplica bordes redondeados al menuContainer
__attribute__((always_inline)) void applyRoundedCornersToMenuContainer(UIView *view, CGFloat cornerRadius) {
    dispatch_async(dispatch_get_main_queue(), ^{
        view.layer.cornerRadius = cornerRadius;
        view.clipsToBounds = YES;
        view.layer.mask = nil; // Eliminar cualquier máscara diagonal
    });
}

// Función para aplicar bordes redondeados normales para otros elementos
__attribute__((always_inline)) void applyRoundedCornersToView(UIView *view, CGFloat cornerRadius) {
    dispatch_async(dispatch_get_main_queue(), ^{
        view.layer.cornerRadius = cornerRadius;
        view.clipsToBounds = YES;
        view.layer.mask = nil; // Eliminar cualquier máscara diagonal
    });
}

// NUEVA FUNCIÓN: Aplicar efecto Glow a una vista
__attribute__((always_inline)) void applyGlowEffectToView(UIView *view, UIColor *glowColor, CGFloat glowRadius) {
    dispatch_async(dispatch_get_main_queue(), ^{
        view.layer.shadowColor = glowColor.CGColor;
        view.layer.shadowOffset = CGSizeZero;
        view.layer.shadowRadius = glowRadius;
        view.layer.shadowOpacity = 0.8;
        view.layer.masksToBounds = NO;
    });
}

// NUEVA FUNCIÓN: Actualizar efecto Glow dinámicamente
__attribute__((always_inline)) void updateGlowEffectForView(UIView *view, UIColor *glowColor, BOOL enabled) {
    dispatch_async(dispatch_get_main_queue(), ^{
        if (enabled) {
            view.layer.shadowColor = glowColor.CGColor;
            view.layer.shadowOffset = CGSizeZero;
            view.layer.shadowRadius = 8.0;
            view.layer.shadowOpacity = 0.6;
            view.layer.masksToBounds = NO;
        } else {
            view.layer.shadowColor = [UIColor clearColor].CGColor;
            view.layer.shadowOpacity = 0.0;
        }
    });
}

- (void)preloadIconsAndFonts {
    // En una implementación real, aquí cargarías los iconos desde Base64
    // Por ahora usamos system icons
    self.iconAimbot = [UIImage systemImageNamed:@"scope"];
    self.iconEye = [UIImage systemImageNamed:@"eye"];
    self.iconMisc = [UIImage systemImageNamed:@"shippingbox"];
    self.iconSettings = [UIImage systemImageNamed:@"slider.horizontal.3"];
    self.iconCheck = [UIImage systemImageNamed:@"checkmark"];
    self.iconWarning = [UIImage systemImageNamed:@"exclamationmark.triangle"];
    self.iconSave = [UIImage systemImageNamed:@"square.and.arrow.down"];
    self.arrowDown = [UIImage systemImageNamed:@"chevron.down"];
    self.iconClose = [UIImage systemImageNamed:@"xmark"];
    self.iconMoon = [UIImage systemImageNamed:@"moon.fill"];
    
    self.fontRegular = [UIFont systemFontOfSize:14];
    self.fontSemiBold = [UIFont boldSystemFontOfSize:14];
    
    self.panelAccentColor = colorValues[selectedColorIndex];
    self.sliderContainers = [NSMutableArray array];
}

- (void)setupMenu {
    [self preloadIconsAndFonts];
    
    // MODIFICADO: Ancho del menú aumentado a 445px (425 + 20 del sidebar reducido)
    CGFloat menuWidth = 445, menuHeight = 340;
    CGSize screenSize = mainWindow.bounds.size;
    CGRect menuFrame = CGRectMake((screenSize.width - menuWidth) / 2,
                                  (screenSize.height - menuHeight) / 2,
                                  menuWidth,
                                  menuHeight);

    self.menuContainer = [[UIView alloc] initWithFrame:menuFrame];
    self.menuContainer.alpha = self.menuAlpha ?: 1.0f;
    self.menuContainer.backgroundColor = [UIColor colorWithRed:11/255.0 green:14/255.0 blue:21/255.0 alpha:1.0];
    [mainWindow addSubview:self.menuContainer];

    // MODIFICADO: Ahora usa bordes redondeados en lugar de corte diagonal para menuContainer
    applyRoundedCornersToMenuContainer(self.menuContainer, 12.0);

    // Sidebar Scroll - MODIFICADO: Ancho reducido a 80px
    self.sidebarScroll = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, 80, menuHeight)];
    self.sidebarScroll.showsVerticalScrollIndicator = YES; // MOSTRAR barra de desplazamiento
    self.sidebarScroll.showsHorizontalScrollIndicator = NO;
    self.sidebarScroll.backgroundColor = [UIColor colorWithRed:11/255.0 green:14/255.0 blue:21/255.0 alpha:1.0];
    [self.menuContainer addSubview:self.sidebarScroll];

    self.sidebarView = [[UIView alloc] initWithFrame:CGRectZero];
    [self.sidebarScroll addSubview:self.sidebarView];

    // Content View - MODIFICADO: Ancho aumentado a 365px (445 - 80)
    self.contentView = [[UIView alloc] initWithFrame:CGRectMake(80, 0, menuWidth - 80, menuHeight)];
    self.contentView.backgroundColor = self.sidebarScroll.backgroundColor;
    [self.menuContainer addSubview:self.contentView];

    // Divider - MODIFICADO: Posición ajustada a 80px
    UIView *divider = [[UIView alloc] initWithFrame:CGRectMake(80, 0, 1, menuHeight)];
    divider.backgroundColor = [UIColor colorWithRed:26/255.0 green:29/255.0 blue:36/255.0 alpha:1.0];
    [self.menuContainer addSubview:divider];

    [self buildSidebar];
    [self updateContentView];
}

- (void)buildSidebar {
    NSArray<NSString *> *tabTitles = @[@"Aimbot", @"Visuals", @"Misc", @"Settings"];
    NSArray<UIImage *> *tabIcons = @[self.iconAimbot, self.iconEye, self.iconMisc, self.iconSettings];

    // MODIFICADO: itemWidth reducido a 80px para sidebar más estrecho
    CGFloat itemHeight = 60, spacing = 10, itemWidth = 80;

    // AGREGADO: Espacio para 2 iconos adicionales en el futuro
    CGFloat totalItems = tabTitles.count + 3; // +3 para el icono X y 2 espacios futuros
    
    for (int i = 0; i < totalItems; i++) {
        // Los últimos 3 items son para el icono X y espacios futuros
        if (i >= tabTitles.count) {
            if (i == tabTitles.count) {
                // Primer espacio futuro
                UIView *futureSpace = [[UIView alloc] initWithFrame:CGRectMake(0, spacing + i * (itemHeight + spacing), itemWidth, itemHeight)];
                futureSpace.backgroundColor = UIColor.clearColor;
                [self.sidebarView addSubview:futureSpace];
                continue;
            }
            else if (i == tabTitles.count + 1) {
                // Segundo espacio futuro
                UIView *futureSpace = [[UIView alloc] initWithFrame:CGRectMake(0, spacing + i * (itemHeight + spacing), itemWidth, itemHeight)];
                futureSpace.backgroundColor = UIColor.clearColor;
                [self.sidebarView addSubview:futureSpace];
                continue;
            }
            else if (i == tabTitles.count + 2) {
                // Icono X para cerrar (último elemento)
                [self addCloseIconAtPosition:i spacing:spacing itemHeight:itemHeight itemWidth:itemWidth];
                continue;
            }
        }

        // Items normales de las pestañas
        UIView *tabItem = [self.sidebarView viewWithTag:1000 + i];
        BOOL selected = (i == self.currentTab);

        if (!tabItem) {
            tabItem = [[UIView alloc] initWithFrame:CGRectMake(0, spacing + i * (itemHeight + spacing), itemWidth, itemHeight)];
            tabItem.tag = 1000 + i;

            // MODIFICADO: Background ahora será 60x60 (80 - 20 = 60)
            UIView *background = [[UIView alloc] initWithFrame:CGRectMake(spacing, 0, itemWidth - spacing * 2, itemHeight)];
            background.tag = 2000;
            [tabItem addSubview:background];

            // MODIFICADO: Iconos redondos (círculos) - ahora centrados en 60px
            UIView *iconContainer = [[UIView alloc] initWithFrame:CGRectMake((background.frame.size.width - 30) / 2, 8, 30, 30)];
            iconContainer.backgroundColor = selected ? self.panelAccentColor : [UIColor colorWithRed:0.3 green:0.3 blue:0.3 alpha:0.5];
            iconContainer.layer.cornerRadius = 15; // Círculo perfecto
            iconContainer.clipsToBounds = YES;
            iconContainer.tag = 2500;
            [background addSubview:iconContainer];

            UIImageView *iconView = [[UIImageView alloc] initWithFrame:CGRectMake(5, 5, 20, 20)];
            iconView.tag = 3000;
            iconView.contentMode = UIViewContentModeScaleAspectFit;
            iconView.tintColor = selected ? UIColor.whiteColor : [UIColor colorWithWhite:0.7 alpha:1.0];
            [iconContainer addSubview:iconView];

            UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(iconContainer.frame) + 2, background.frame.size.width, 20)];
            label.textAlignment = NSTextAlignmentCenter;
            label.font = [UIFont systemFontOfSize:11 weight:UIFontWeightMedium];
            label.tag = 4000;
            label.textColor = selected ? UIColor.whiteColor : [UIColor colorWithWhite:0.7 alpha:1.0];
            [background addSubview:label];

            UIButton *tap = [[UIButton alloc] initWithFrame:tabItem.bounds];
            tap.backgroundColor = UIColor.clearColor;
            tap.tag = i;
            [tap addTarget:self action:@selector(didTapTab:) forControlEvents:UIControlEventTouchUpInside];
            [tabItem addSubview:tap];

            [self.sidebarView addSubview:tabItem];
        }

        UIView *bg = [tabItem viewWithTag:2000];
        UIView *iconContainer = [bg viewWithTag:2500];
        UIImageView *icon = [iconContainer viewWithTag:3000];
        UILabel *label = [bg viewWithTag:4000];

        bg.backgroundColor = selected ? [UIColor colorWithRed:6/255.0 green:9/255.0 blue:14/255.0 alpha:1.0] : UIColor.clearColor;
        icon.image = [tabIcons[i] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
        icon.tintColor = selected ? UIColor.whiteColor : [UIColor colorWithWhite:0.7 alpha:1.0];
        
        // ACTUALIZAR COLOR DEL CONTENEDOR DEL ICONO
        iconContainer.backgroundColor = selected ? self.panelAccentColor : [UIColor colorWithRed:0.3 green:0.3 blue:0.3 alpha:0.5];
        
        label.text = tabTitles[i];
        label.textColor = selected ? UIColor.whiteColor : [UIColor colorWithWhite:0.7 alpha:1.0];

        for (UIView *sub in bg.subviews) {
            if (sub.frame.size.width == 4) [sub removeFromSuperview];
        }

        if (selected) {
            UIView *bar = [[UIView alloc] initWithFrame:CGRectMake(bg.frame.size.width - 4, 0, 4, itemHeight)];
            bar.backgroundColor = self.panelAccentColor;
            bar.alpha = 0.0;
            [bg addSubview:bar];
            [UIView animateWithDuration:0.25 animations:^{ bar.alpha = 1.0; }];

            // CAMBIADO: Ahora usa esquinas redondeadas en lugar de corte diagonal
            applyRoundedCornersToView(bg, 8.0);
        } else {
            bg.layer.mask = nil;
            bg.layer.cornerRadius = 0;
        }
    }

    CGFloat totalHeight = spacing + totalItems * (itemHeight + spacing);
    // MODIFICADO: Ancho del sidebar reducido a 80px
    self.sidebarView.frame = CGRectMake(0, 0, 80, totalHeight);
    self.sidebarScroll.contentSize = CGSizeMake(80, totalHeight);
}

- (void)addCloseIconAtPosition:(int)position spacing:(CGFloat)spacing itemHeight:(CGFloat)itemHeight itemWidth:(CGFloat)itemWidth {
    UIView *closeItem = [[UIView alloc] initWithFrame:CGRectMake(0, spacing + position * (itemHeight + spacing), itemWidth, itemHeight)];
    closeItem.tag = 5000; // Tag especial para el icono de cerrar

    // Fondo con el mismo diseño que los iconos de pestañas
    UIView *background = [[UIView alloc] initWithFrame:CGRectMake(spacing, 0, itemWidth - spacing * 2, itemHeight)];
    background.tag = 2000;
    background.backgroundColor = UIColor.clearColor;
    [closeItem addSubview:background];

    // Contenedor del icono X - igual diseño que los otros iconos
    UIView *iconContainer = [[UIView alloc] initWithFrame:CGRectMake((background.frame.size.width - 30) / 2, 8, 30, 30)];
    iconContainer.backgroundColor = [UIColor colorWithRed:0.3 green:0.3 blue:0.3 alpha:0.5];
    iconContainer.layer.cornerRadius = 15; // Círculo perfecto igual que los otros
    iconContainer.clipsToBounds = YES;
    iconContainer.tag = 2500;
    [background addSubview:iconContainer];

    // Icono X con el mismo tamaño y diseño
    UIImageView *iconView = [[UIImageView alloc] initWithFrame:CGRectMake(5, 5, 20, 20)];
    iconView.image = [self.iconClose imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    iconView.tintColor = [UIColor colorWithWhite:0.7 alpha:1.0];
    iconView.contentMode = UIViewContentModeScaleAspectFit;
    iconView.tag = 3000;
    [iconContainer addSubview:iconView];

    // Label "CLOSE"
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(iconContainer.frame) + 2, background.frame.size.width, 20)];
    label.text = @"CLOSE";
    label.textAlignment = NSTextAlignmentCenter;
    label.font = [UIFont systemFontOfSize:11 weight:UIFontWeightMedium];
    label.tag = 4000;
    label.textColor = [UIColor colorWithWhite:0.7 alpha:1.0];
    [background addSubview:label];

    // Botón para cerrar
    UIButton *closeButton = [[UIButton alloc] initWithFrame:closeItem.bounds];
    closeButton.backgroundColor = UIColor.clearColor;
    [closeButton addTarget:self action:@selector(closeMenu) forControlEvents:UIControlEventTouchUpInside];
    [closeItem addSubview:closeButton];

    [self.sidebarView addSubview:closeItem];
}

- (void)didTapTab:(UIButton *)sender {
    NSInteger selectedIndex = sender.tag;
    if (selectedIndex == self.currentTab) return;

    UIView *prevTabItem = [self.sidebarView viewWithTag:1000 + self.currentTab];
    UIView *newTabItem  = [self.sidebarView viewWithTag:1000 + selectedIndex];

    if (prevTabItem) {
        UIView *bg = [prevTabItem viewWithTag:2000];
        UIView *iconContainer = [bg viewWithTag:2500];
        UIImageView *icon = [iconContainer viewWithTag:3000];
        UILabel *label = [bg viewWithTag:4000];

        UIView *bar = nil;
        for (UIView *sub in bg.subviews) {
            if (sub.frame.size.width == 4) {
                bar = sub;
                break;
            }
        }

        [UIView animateWithDuration:0.3 animations:^{
            bg.backgroundColor = UIColor.clearColor;
            iconContainer.backgroundColor = [UIColor colorWithRed:0.3 green:0.3 blue:0.3 alpha:0.5];
            icon.transform = CGAffineTransformIdentity;
            icon.alpha = 0.6;
            label.alpha = 0.6;
            label.transform = CGAffineTransformIdentity;
            bar.alpha = 0.0;
        } completion:^(BOOL finished) {
            [bar removeFromSuperview];
        }];
    }

    if (newTabItem) {
        UIView *bg = [newTabItem viewWithTag:2000];
        UIView *iconContainer = [bg viewWithTag:2500];
        UIImageView *icon = [iconContainer viewWithTag:3000];
        UILabel *label = [bg viewWithTag:4000];

        bg.backgroundColor = [UIColor clearColor];
        bg.layer.mask = nil;
        // CAMBIADO: Ahora usa esquinas redondeadas en lugar de corte diagonal
        applyRoundedCornersToView(bg, 8.0);
        
        icon.transform = CGAffineTransformMakeScale(0.95, 0.95);
        icon.alpha = 0.0;
        label.alpha = 0.0;
        label.transform = CGAffineTransformMakeScale(0.95, 0.95);

        UIView *bar = [[UIView alloc] initWithFrame:CGRectMake(bg.frame.size.width, 0, 4, bg.frame.size.height)];
        bar.backgroundColor = self.panelAccentColor;
        bar.alpha = 0.0;
        [bg addSubview:bar];

        [UIView animateWithDuration:0.35 delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
            bg.backgroundColor = [UIColor colorWithRed:6/255.0 green:9/255.0 blue:14/255.0 alpha:1.0];
            iconContainer.backgroundColor = self.panelAccentColor;
        } completion:nil];

        [UIView animateWithDuration:0.35 delay:0.05 options:UIViewAnimationOptionCurveEaseOut animations:^{
            icon.transform = CGAffineTransformIdentity;
            icon.alpha = 1.0;
            label.transform = CGAffineTransformIdentity;
            label.alpha = 1.0;
        } completion:nil];

        [UIView animateWithDuration:0.4 delay:0.1 options:UIViewAnimationOptionCurveEaseOut animations:^{
            bar.frame = CGRectMake(bg.frame.size.width - 4, 0, 4, bg.frame.size.height);
            bar.alpha = 1.0;
        } completion:nil];

        icon.tintColor = UIColor.whiteColor;
        label.textColor = UIColor.whiteColor;
    }

    self.currentTab = (MenuTab)selectedIndex;
    [self updateContentView];
}

- (void)updateContentView {
    // Limpiar vista anterior
    if (self.aimbotView) self.aimbotView.hidden = YES;
    if (self.visualsView) self.visualsView.hidden = YES;
    if (self.miscView) self.miscView.hidden = YES;
    if (self.settingsView) self.settingsView.hidden = YES;

    for (UIView *sub in self.contentView.subviews) {
        if (sub.tag == 9999) {
            [sub removeFromSuperview];
        }
    }

    // Header - MODIFICADO: Ahora con 44px de altura y diseño mejorado
    CGFloat paddingSide = 14;
    CGFloat paddingTop = 14;
    CGFloat headerHeight = 44; // MODIFICADO: 44px de altura

    UIView *header = [[UIView alloc] initWithFrame:CGRectMake(paddingSide, paddingTop, self.contentView.bounds.size.width - paddingSide * 2, headerHeight)];
    header.tag = 9999;
    header.backgroundColor = [UIColor colorWithRed:6/255.0 green:9/255.0 blue:14/255.0 alpha:1.0];
    header.clipsToBounds = YES;
    // CAMBIADO: Ahora usa esquinas redondeadas como los checkboxes
    applyRoundedCornersToView(header, headerHeight / 2.0); // 180° = altura/2
    
    [self.contentView addSubview:header];

    // AGREGADO: Gesto para mover SOLO desde el header - IGUAL QUE EN EL SEGUNDO PROYECTO
    UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handlePan:)];
    pan.delaysTouchesBegan = NO;
    pan.cancelsTouchesInView = NO;
    [header addGestureRecognizer:pan];

    // MANTENIDO IGUAL: Arrays de íconos y títulos (sin descripciones)
    NSArray *icons = @[self.iconAimbot, self.iconEye, self.iconMisc, self.iconSettings];
    NSArray *titles = @[@"AIMBOT", @"VISUALS", @"MISC", @"SETTINGS"];

    // MODIFICADO: Nueva disposición de elementos en el header
    CGFloat iconSize = 20;
    CGFloat spacing = 8;
    
    // Icono de la pestaña actual (izquierda)
    UIImage *iconImage = [icons[self.currentTab] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    UIImageView *iconView = [[UIImageView alloc] initWithImage:iconImage];
    iconView.tintColor = self.panelAccentColor;
    iconView.frame = CGRectMake(12, (headerHeight - iconSize) / 2, iconSize, iconSize);
    iconView.contentMode = UIViewContentModeScaleAspectFit;
    [header addSubview:iconView];

    // Título de la pestaña actual
    UILabel *titleLabel = [[UILabel alloc] init];
    titleLabel.font = self.fontSemiBold;
    titleLabel.textColor = self.panelAccentColor;
    titleLabel.text = titles[self.currentTab];
    [titleLabel sizeToFit];
    CGFloat titleX = CGRectGetMaxX(iconView.frame) + spacing;
    titleLabel.frame = CGRectMake(titleX, 0, titleLabel.frame.size.width, headerHeight);
    [header addSubview:titleLabel];

    // AGREGADO: Icono Moon (modo oscuro) - lado izquierdo del header
    CGFloat moonIconSize = 20;
    CGFloat moonIconX = CGRectGetMaxX(titleLabel.frame) + 20; // Espacio después del título
    
    UIView *moonContainer = [[UIView alloc] initWithFrame:CGRectMake(moonIconX, (headerHeight - moonIconSize) / 2, moonIconSize, moonIconSize)];
    moonContainer.backgroundColor = DarkMode ? self.panelAccentColor : [UIColor colorWithRed:0.3 green:0.3 blue:0.3 alpha:0.5];
    moonContainer.layer.cornerRadius = moonIconSize / 2.0; // Círculo perfecto
    moonContainer.clipsToBounds = YES;
    moonContainer.tag = 6000;
    [header addSubview:moonContainer];

    UIImageView *moonIcon = [[UIImageView alloc] initWithImage:[self.iconMoon imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate]];
    moonIcon.tintColor = DarkMode ? UIColor.whiteColor : [UIColor colorWithWhite:0.7 alpha:1.0];
    moonIcon.frame = CGRectMake(2, 2, moonIconSize - 4, moonIconSize - 4);
    moonIcon.contentMode = UIViewContentModeScaleAspectFit;
    moonIcon.tag = 6001;
    [moonContainer addSubview:moonIcon];

    // Botón para toggle del modo oscuro
    UIButton *moonButton = [[UIButton alloc] initWithFrame:CGRectMake(moonIconX - 5, 0, moonIconSize + 10, headerHeight)];
    moonButton.backgroundColor = UIColor.clearColor;
    [moonButton addAction:[UIAction actionWithHandler:^(__kindof UIAction * _Nonnull action) {
        DarkMode = !DarkMode;
        
        [UIView animateWithDuration:0.3 animations:^{
            if (DarkMode) {
                moonContainer.backgroundColor = self.panelAccentColor;
                moonIcon.tintColor = UIColor.whiteColor;
            } else {
                moonContainer.backgroundColor = [UIColor colorWithRed:0.3 green:0.3 blue:0.3 alpha:0.5];
                moonIcon.tintColor = [UIColor colorWithWhite:0.7 alpha:1.0];
            }
        }];
        
        // [self playActivationSound]; - Removed by user request
    }] forControlEvents:UIControlEventTouchUpInside];
    [header addSubview:moonButton];

    // AGREGADO: Espacio para segundo icono futuro
    CGFloat futureIconX = CGRectGetMaxX(moonContainer.frame) + 8;
    UIView *futureIconSpace = [[UIView alloc] initWithFrame:CGRectMake(futureIconX, (headerHeight - moonIconSize) / 2, moonIconSize, moonIconSize)];
    futureIconSpace.backgroundColor = [UIColor colorWithRed:0.3 green:0.3 blue:0.3 alpha:0.3];
    futureIconSpace.layer.cornerRadius = moonIconSize / 2.0;
    futureIconSpace.clipsToBounds = YES;
    futureIconSpace.alpha = 0.5;
    [header addSubview:futureIconSpace];

    // Contenido específico de cada pestaña - MODIFICADO: Ahora usa UIScrollView
    CGFloat startY = CGRectGetMaxY(header.frame) + 14;
    CGRect contentFrame = CGRectMake(0, startY, self.contentView.bounds.size.width, self.contentView.bounds.size.height - startY);

    switch (self.currentTab) {
        case MenuTabAimbot:
            if (!self.aimbotView) {
                self.aimbotView = [[UIView alloc] initWithFrame:contentFrame];
                self.aimbotView.backgroundColor = UIColor.clearColor;
                [self buildAimbotView];
                [self.contentView addSubview:self.aimbotView];
            }
            self.aimbotView.hidden = NO;
            break;
        case MenuTabVisuals:
            if (!self.visualsView) {
                self.visualsView = [[UIView alloc] initWithFrame:contentFrame];
                self.visualsView.backgroundColor = UIColor.clearColor;
                [self buildVisualsView];
                [self.contentView addSubview:self.visualsView];
            }
            self.visualsView.hidden = NO;
            break;
        case MenuTabMisc:
            if (!self.miscView) {
                self.miscView = [[UIView alloc] initWithFrame:contentFrame];
                self.miscView.backgroundColor = UIColor.clearColor;
                [self buildMiscView];
                [self.contentView addSubview:self.miscView];
            }
            self.miscView.hidden = NO;
            break;
        case MenuTabSettings:
            if (!self.settingsView) {
                self.settingsView = [[UIView alloc] initWithFrame:contentFrame];
                self.settingsView.backgroundColor = UIColor.clearColor;
                [self buildSettingsView];
                [self.contentView addSubview:self.settingsView];
            }
            self.settingsView.hidden = NO;
            break;
    }
}

#pragma mark - Vistas Específicas MODIFICADAS con UIScrollView

- (void)buildAimbotView {
    CGFloat scrollPadding = 12;
    CGFloat contentWidth = self.aimbotView.bounds.size.width - scrollPadding * 2;
    CGFloat availableHeight = self.aimbotView.bounds.size.height;

    UIScrollView *scroll = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, self.aimbotView.bounds.size.width, availableHeight)];
    scroll.backgroundColor = UIColor.clearColor;
    scroll.showsVerticalScrollIndicator = YES;
    [self.aimbotView addSubview:scroll];

    UIView *container = [[UIView alloc] initWithFrame:CGRectMake(0, 0, scroll.bounds.size.width, 1)];
    container.backgroundColor = UIColor.clearColor;
    [scroll addSubview:container];

    CGFloat currentY = 0;

    [self addCheckboxTo:container atY:&currentY withText:@"Aimbot" enabledRef:&Vars.Aimbot isWarning:NO];
    
    // === SEPARADOR 1 ===
    currentY += 10;
    UIView *divider1 = [[UIView alloc] initWithFrame:CGRectMake(14, currentY, contentWidth, 1)];
    divider1.backgroundColor = [UIColor colorWithRed:26/255.0 green:29/255.0 blue:36/255.0 alpha:1.0];
    [container addSubview:divider1];
    currentY += 16;

    // MODIFICADO: AimKill movido hacia la izquierda - ICONO DE ADVERTENCIA AHORA A LA IZQUIERDA
    [self addCheckboxTo:container atY:&currentY withText:@"AimKill" enabledRef:&Vars.aimkill isWarning:YES];
    
    [self addCheckboxTo:container atY:&currentY withText:@"Ignore Knocked" enabledRef:&Vars.IgnoreKnocked isWarning:NO];

    // === SEPARADOR 2 ===
    currentY += 10;
    UIView *divider2 = [[UIView alloc] initWithFrame:CGRectMake(14, currentY, contentWidth, 1)];
    divider2.backgroundColor = [UIColor colorWithRed:26/255.0 green:29/255.0 blue:36/255.0 alpha:1.0];
    [container addSubview:divider2];
    currentY += 16;

    // === SEPARADOR 3 ===
    currentY += 15;
    UIView *divider3 = [[UIView alloc] initWithFrame:CGRectMake(14, currentY, contentWidth, 1)];
    divider3.backgroundColor = [UIColor colorWithRed:26/255.0 green:29/255.0 blue:36/255.0 alpha:1.0];
    [container addSubview:divider3];
    currentY += 16;

    // === NUEVO COMBOBOX TARGET BONE ===
    NSArray *boneOptions = @[@"Head", @"Neck", @"Body"];
    NSArray *boneWarnings = @[@1, @0, @0]; // Warning solo en Head
    
    [self addComboBoxTo:container 
                   atY:&currentY 
             withTitle:@"Aim Mode" 
               options:boneOptions 
         selectedIndex:&Vars.AimHitbox 
           hasWarning:boneWarnings 
               action:^(int newIndex) {
        Vars.AimHitbox = newIndex;
        NSLog(@"Target bone changed to: %@", boneOptions[newIndex]);
    }];
    
    // === SEPARADOR 4 ===
    currentY += 15;
    UIView *divider4 = [[UIView alloc] initWithFrame:CGRectMake(14, currentY, contentWidth, 1)];
    divider4.backgroundColor = [UIColor colorWithRed:26/255.0 green:29/255.0 blue:36/255.0 alpha:1.0];
    [container addSubview:divider4];
    currentY += 16;

    // === NUEVO CHECKBOX AIM FOV ===
    [self addCheckboxTo:container atY:&currentY withText:@"Aim FOV" enabledRef:&Vars.isAimFov isWarning:NO];

    // === SEPARADOR 5 ===
    currentY += 10;
    UIView *divider5 = [[UIView alloc] initWithFrame:CGRectMake(14, currentY, contentWidth, 1)];
    divider5.backgroundColor = [UIColor colorWithRed:26/255.0 green:29/255.0 blue:36/255.0 alpha:1.0];
    [container addSubview:divider5];
    currentY += 16;

    // ELIMINADO: Slider de Aim Speed - COMPLETAMENTE REMOVIDO

    // Slider de Aim FOV
    [self addSliderTo:container atY:&currentY withText:@"Aim FOV" valueRef:&Vars.AimFov min:1.0f max:360.0f onChange:nil];

    // Ajustar el tamaño del contenedor y el scroll
    container.frame = CGRectMake(0, 0, contentWidth + scrollPadding, currentY + 5);
    scroll.contentSize = container.frame.size;
}

- (void)buildVisualsView {
    CGFloat scrollPadding = 12;
    CGFloat contentWidth = self.visualsView.bounds.size.width - scrollPadding * 2;
    CGFloat availableHeight = self.visualsView.bounds.size.height;

    UIScrollView *scroll = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, self.visualsView.bounds.size.width, availableHeight)];
    scroll.backgroundColor = UIColor.clearColor;
    scroll.showsVerticalScrollIndicator = YES;
    [self.visualsView addSubview:scroll];

    UIView *container = [[UIView alloc] initWithFrame:CGRectMake(0, 0, scroll.bounds.size.width, 1)];
    container.backgroundColor = UIColor.clearColor;
    [scroll addSubview:container];

    CGFloat currentY = 0;

    [self addCheckboxTo:container atY:&currentY withText:@"Line" enabledRef:&Vars.lines isWarning:NO];
    [self addCheckboxTo:container atY:&currentY withText:@"Box" enabledRef:&Vars.Box isWarning:NO];

    // === SEPARADOR 1 ===
    currentY += 10;
    UIView *divider1 = [[UIView alloc] initWithFrame:CGRectMake(14, currentY, contentWidth, 1)];
    divider1.backgroundColor = [UIColor colorWithRed:26/255.0 green:29/255.0 blue:36/255.0 alpha:1.0];
    [container addSubview:divider1];
    currentY += 16;

    // === NUEVOS CHECKBOXES NAME Y HEALTH ===
    [self addCheckboxTo:container atY:&currentY withText:@"Name" enabledRef:&Vars.Name isWarning:NO];
    [self addCheckboxTo:container atY:&currentY withText:@"Skeleton" enabledRef:&Vars.skeleton isWarning:NO];
    [self addCheckboxTo:container atY:&currentY withText:@"Skeleton Wallhack" enabledRef:&Vars.skeletonWallhack isWarning:YES];
    
    // === SEPARADOR 2 ===
    currentY += 10;
    UIView *divider2 = [[UIView alloc] initWithFrame:CGRectMake(14, currentY, contentWidth, 1)];
    divider2.backgroundColor = [UIColor colorWithRed:26/255.0 green:29/255.0 blue:36/255.0 alpha:1.0];
    [container addSubview:divider2];
    currentY += 16;

    // === COMBOBOX BOX STYLE ===
    NSArray *boxStyleOptions = @[@"Normal", @"Cornered", @"Round"];
    NSArray *boxStyleWarnings = @[@0, @0, @0];
    
    [self addComboBoxTo:container 
                   atY:&currentY 
             withTitle:@"Box Style" 
               options:boxStyleOptions 
         selectedIndex:&Vars.BoxStyle 
           hasWarning:boxStyleWarnings 
               action:^(int newIndex) {
        Vars.BoxStyle = newIndex;
        NSLog(@"Box style changed to: %@", boxStyleOptions[newIndex]);
    }];

    // === COMBOBOX LINE STYLE ===
    NSArray *lineStyleOptions = @[@"Top", @"Bottom"];
    NSArray *lineStyleWarnings = @[@0, @0];
    
    [self addComboBoxTo:container 
                   atY:&currentY 
             withTitle:@"Line Style" 
               options:lineStyleOptions 
         selectedIndex:&Vars.LineStyle 
           hasWarning:lineStyleWarnings 
               action:^(int newIndex) {
        Vars.LineStyle = newIndex;
        NSLog(@"Line style changed to: %@", lineStyleOptions[newIndex]);
    }];

    // === COMBOBOX NAME STYLE ===
    NSArray *nameStyleOptions = @[@"With Shadow", @"Without Shadow"];
    NSArray *nameStyleWarnings = @[@0, @0];
    
    [self addComboBoxTo:container 
                   atY:&currentY 
             withTitle:@"Name Style" 
               options:nameStyleOptions 
         selectedIndex:&Vars.NameStyle 
           hasWarning:nameStyleWarnings 
               action:^(int newIndex) {
        Vars.NameStyle = newIndex;
        NSLog(@"Name style changed to: %@", nameStyleOptions[newIndex]);
    }];

    // === COMBOBOX HEALTH POSITION ===
    NSArray *healthPosOptions = @[@"Left", @"Right"];
    NSArray *healthPosWarnings = @[@0, @0];
    
    [self addComboBoxTo:container 
                   atY:&currentY 
             withTitle:@"Health Position" 
               options:healthPosOptions 
         selectedIndex:&Vars.HealthPos 
           hasWarning:healthPosWarnings 
               action:^(int newIndex) {
        Vars.HealthPos = newIndex;
        NSLog(@"Health position changed to: %@", healthPosOptions[newIndex]);
    }];

    // Ajustar el tamaño del contenedor y el scroll
    container.frame = CGRectMake(0, 0, contentWidth + scrollPadding, currentY + 5);
    scroll.contentSize = container.frame.size;
}

- (void)buildMiscView {
    CGFloat scrollPadding = 12;
    CGFloat contentWidth = self.miscView.bounds.size.width - scrollPadding * 2;
    CGFloat availableHeight = self.miscView.bounds.size.height;

    UIScrollView *scroll = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, self.miscView.bounds.size.width, availableHeight)];
    scroll.backgroundColor = UIColor.clearColor;
    scroll.showsVerticalScrollIndicator = YES;
    [self.miscView addSubview:scroll];

    UIView *container = [[UIView alloc] initWithFrame:CGRectMake(0, 0, scroll.bounds.size.width, 1)];
    container.backgroundColor = UIColor.clearColor;
    [scroll addSubview:container];

    CGFloat currentY = 0;

    [self addCheckboxTo:container atY:&currentY withText:@"No Recoil" enabledRef:&norecoil isWarning:NO];
    [self addCheckboxTo:container atY:&currentY withText:@"Fast Weapon Swap" enabledRef:&swapweapon isWarning:NO];
    [self addCheckboxTo:container atY:&currentY withText:@"Force 120 FPS" enabledRef:&forceHighFPS isWarning:NO];
    [self addCheckboxTo:container atY:&currentY withText:@"Reset Guest" enabledRef:&resetguest isWarning:NO];

    // Ajustar el tamaño del contenedor y el scroll
    container.frame = CGRectMake(0, 0, contentWidth + scrollPadding, currentY + 5);
    scroll.contentSize = container.frame.size;
}

- (void)buildSettingsView {
    CGFloat scrollPadding = 12;
    CGFloat contentWidth = self.settingsView.bounds.size.width - scrollPadding * 2;
    CGFloat availableHeight = self.settingsView.bounds.size.height;

    UIScrollView *scroll = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, self.settingsView.bounds.size.width, availableHeight)];
    scroll.backgroundColor = UIColor.clearColor;
    scroll.showsVerticalScrollIndicator = YES;
    [self.settingsView addSubview:scroll];

    UIView *container = [[UIView alloc] initWithFrame:CGRectMake(0, 0, scroll.bounds.size.width, 1)];
    container.backgroundColor = UIColor.clearColor;
    [scroll addSubview:container];

    CGFloat currentY = 0;

    [self addCheckboxTo:container atY:&currentY withText:@"Streamproof" enabledRef:&StreamerMode isWarning:NO];
    
    currentY += 8;
    
    // === SEPARADOR 1 ===
    UIView *divider1 = [[UIView alloc] initWithFrame:CGRectMake(14, currentY, contentWidth, 1)];
    divider1.backgroundColor = [UIColor colorWithRed:26/255.0 green:29/255.0 blue:36/255.0 alpha:1.0];
    [container addSubview:divider1];
    currentY += 16;
    
    // Slider de transparencia del menú
    [self addSliderTo:container atY:&currentY withText:@"Menu Transparency" valueRef:&_menuAlpha min:0.5f max:1.0f onChange:^(float newAlpha) {
        self.menuAlpha = fmaxf(0.5f, fminf(newAlpha, 1.0f));
        if (self.menuContainer)
            self.menuContainer.alpha = self.menuAlpha;
    }];
    
    // === SEPARADOR 2 ===
    currentY += 15;
    UIView *divider2 = [[UIView alloc] initWithFrame:CGRectMake(14, currentY, contentWidth, 1)];
    divider2.backgroundColor = [UIColor colorWithRed:26/255.0 green:29/255.0 blue:36/255.0 alpha:1.0];
    [container addSubview:divider2];
    currentY += 16;
    
    // Selector de color
    __weak __typeof(self) weakSelf = self;
    [self addComboBoxTo:container atY:&currentY withTitle:@"Theme Color" options:@[@"Purple", @"Red", @"Cyan", @"Dark Blue", @"Yellow", @"Green", @"Orange", @"Pink", @"Teal", @"Indigo", @"Lime", @"Brown", @"Sky Blue", @"Rose", @"Lavender", @"Mint", @"Coral", @"Turquoise", @"Gold", @"Silver", @"Neon Green", @"Neon Pink", @"Deep Purple", @"Crimson", @"Electric Blue", @"Sunset Orange"] selectedIndex:&selectedColorIndex hasWarning:@[@0, @0, @0, @0, @0, @0, @0, @0, @0, @0, @0, @0, @0, @0, @0, @0, @0, @0, @0, @0, @0, @0, @0, @0, @0, @0] action:^(int newIndex) {
        __strong __typeof(weakSelf) strongSelf = weakSelf;
        if (strongSelf) {
            selectedColorIndex = newIndex;
            strongSelf.panelAccentColor = colorValues[newIndex];
            
            // ACTUALIZACIÓN EN TIEMPO REAL COMPLETA - MÉTODO MEJORADO
            [strongSelf updateAllColorsInRealTime];
        }
    }];

    // Ajustar el tamaño del contenedor y el scroll
    container.frame = CGRectMake(0, 0, contentWidth + scrollPadding, currentY + 5);
    scroll.contentSize = container.frame.size;
}

#pragma mark - Sistema de Actualización de Colores en Tiempo Real MEJORADO

- (void)updateAllColorsInRealTime {
    // Actualizar sidebar
    [self updateSidebarColors];
    
    // Actualizar header
    [self updateHeaderColors];
    
    // Actualizar sliders - MÉTODO MEJORADO
    [self updateAllSlidersColor];
    
    // Actualizar checkboxes
    [self updateCheckboxColors];
    
    // Actualizar comboboxes
    [self updateComboBoxColors];
    
    // Actualizar icono moon
    [self updateMoonIconColor];
    
    // Forzar redibujado de todas las vistas
    [self.menuContainer setNeedsDisplay];
    [self.contentView setNeedsDisplay];
}

- (void)updateMoonIconColor {
    UIView *header = [self.contentView viewWithTag:9999];
    if (header) {
        UIView *moonContainer = [header viewWithTag:6000];
        UIImageView *moonIcon = [header viewWithTag:6001];
        
        if (moonContainer && moonIcon) {
            [UIView animateWithDuration:0.3 animations:^{
                if (DarkMode) {
                    moonContainer.backgroundColor = self.panelAccentColor;
                    moonIcon.tintColor = UIColor.whiteColor;
                } else {
                    moonContainer.backgroundColor = [UIColor colorWithRed:0.3 green:0.3 blue:0.3 alpha:0.5];
                    moonIcon.tintColor = [UIColor colorWithWhite:0.7 alpha:1.0];
                }
            }];
        }
    }
}

- (void)updateSidebarColors {
    for (int i = 0; i < 4; i++) {
        UIView *tabItem = [self.sidebarView viewWithTag:1000 + i];
        if (tabItem) {
            UIView *bg = [tabItem viewWithTag:2000];
            UIView *iconContainer = [bg viewWithTag:2500];
            
            BOOL selected = (i == self.currentTab);
            
            if (selected) {
                // Actualizar barra de selección
                for (UIView *sub in bg.subviews) {
                    if (sub.frame.size.width == 4) {
                        sub.backgroundColor = self.panelAccentColor;
                        break;
                    }
                }
                
                // Actualizar color del contenedor del icono
                iconContainer.backgroundColor = self.panelAccentColor;
            }
        }
    }
}

- (void)updateHeaderColors {
    UIView *header = [self.contentView viewWithTag:9999];
    if (header) {
        for (UIView *subview in header.subviews) {
            if ([subview isKindOfClass:[UIImageView class]]) {
                UIImageView *iconView = (UIImageView *)subview;
                // Solo actualizar el icono de la pestaña, no el moon
                if (iconView.tag != 6001) {
                    iconView.tintColor = self.panelAccentColor;
                }
            } else if ([subview isKindOfClass:[UILabel class]]) {
                UILabel *label = (UILabel *)subview;
                if ([label.text isEqualToString:@"AIMBOT"] || [label.text isEqualToString:@"VISUALS"] || 
                    [label.text isEqualToString:@"MISC"] || [label.text isEqualToString:@"SETTINGS"]) {
                    label.textColor = self.panelAccentColor;
                }
            }
        }
    }
}

- (void)updateAllSlidersColor {
    // Usar el array de sliderContainers para actualizar específicamente
    for (UIView *sliderContainer in self.sliderContainers) {
        [self updateSliderColorInContainer:sliderContainer];
    }
}

- (void)updateSliderColorInContainer:(UIView *)sliderContainer {
    // Buscar y actualizar la barra de progreso (fill)
    UIView *fillView = [sliderContainer viewWithTag:7000];
    if (fillView) {
        fillView.backgroundColor = self.panelAccentColor;
    }
    
    // Buscar y actualizar el thumb (círculo deslizante)
    UIView *thumbView = [sliderContainer viewWithTag:7001];
    if (thumbView) {
        thumbView.layer.borderColor = self.panelAccentColor.CGColor;
    }
    
    // Actualizar también el texto del label del slider
    for (UIView *superview in sliderContainer.superview.subviews) {
        if ([superview isKindOfClass:[UILabel class]]) {
            UILabel *sliderLabel = (UILabel *)superview;
            NSString *currentText = sliderLabel.text;
            if (currentText && [currentText containsString:@"×"]) {
                NSRange range = [currentText rangeOfString:@"×" options:NSBackwardsSearch];
                if (range.location != NSNotFound) {
                    NSString *valuePart = [currentText substringFromIndex:range.location - 4]; // Aproximadamente " X.×"
                    NSString *textPart = [currentText substringToIndex:range.location - 4];
                    
                    NSMutableAttributedString *attr = [[NSMutableAttributedString alloc] initWithString:currentText];
                    [attr addAttribute:NSForegroundColorAttributeName
                                 value:[UIColor colorWithRed:0.7 green:0.7 blue:0.7 alpha:1.0]
                                 range:NSMakeRange(0, textPart.length)];
                    [attr addAttribute:NSForegroundColorAttributeName
                                 value:self.panelAccentColor
                                 range:NSMakeRange(textPart.length, valuePart.length)];
                    sliderLabel.attributedText = attr;
                }
            }
        }
    }
}

- (void)updateCheckboxColors {
    [self updateCheckboxColorsInView:self.aimbotView];
    [self updateCheckboxColorsInView:self.visualsView];
    [self updateCheckboxColorsInView:self.miscView];
    [self updateCheckboxColorsInView:self.settingsView];
}

- (void)updateCheckboxColorsInView:(UIView *)view {
    if (!view) return;
    
    for (UIView *subview in view.subviews) {
        if (subview.tag == 8000) { // Tag de checkbox box
            UIView *box = subview;
            // Verificar si el checkbox está activado
            BOOL isEnabled = NO;
            for (UIView *checkView in box.subviews) {
                if ([checkView isKindOfClass:[UIImageView class]] && !checkView.hidden) {
                    isEnabled = YES;
                    break;
                }
            }
            
            if (isEnabled) {
                [UIView animateWithDuration:0.25 animations:^{
                    box.backgroundColor = self.panelAccentColor;
                }];
            }
        }
        
        [self updateCheckboxColorsInView:subview];
    }
}

- (void)updateComboBoxColors {
    [self updateComboBoxColorsInView:self.aimbotView];
    [self updateComboBoxColorsInView:self.visualsView];
    [self updateComboBoxColorsInView:self.settingsView];
}

- (void)updateComboBoxColorsInView:(UIView *)view {
    if (!view) return;
    
    for (UIView *subview in view.subviews) {
        if ([subview isKindOfClass:[UIImageView class]]) {
            UIImageView *arrowIcon = (UIImageView *)subview;
            if (arrowIcon.image == [self.arrowDown imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate]) {
                arrowIcon.tintColor = self.panelAccentColor;
            }
        }
        
        [self updateComboBoxColorsInView:subview];
    }
}

#pragma mark - Componentes UI

- (void)addCheckboxTo:(UIView *)parent atY:(CGFloat *)currentY withText:(NSString *)text enabledRef:(BOOL *)enabledRef isWarning:(BOOL)isWarning {
    CGFloat paddingX = 14;
    CGFloat rowHeight = 44;
    CGFloat checkboxSize = 22;
    CGFloat spacing = 12;

    // CONTENEDOR PRINCIPAL CON FONDO REDONDEADO COMPLETO (180°)
    UIView *rowContainer = [[UIView alloc] initWithFrame:CGRectMake(paddingX, *currentY, parent.bounds.size.width - paddingX * 2, rowHeight)];
    rowContainer.backgroundColor = [UIColor colorWithRed:25/255.0 green:32/255.0 blue:40/255.0 alpha:1.0];
    rowContainer.clipsToBounds = YES;
    
    // APLICAR ESQUINAS REDONDEADAS COMPLETAS AL CONTENEDOR (180°)
    applyRoundedCornersToView(rowContainer, rowHeight / 2.0); // 180° = altura/2
    
    // EFECTO DE BORDE SUAVE
    rowContainer.layer.borderWidth = 1.0;
    rowContainer.layer.borderColor = [UIColor colorWithRed:40/255.0 green:47/255.0 blue:55/255.0 alpha:1.0].CGColor;
    
    [parent addSubview:rowContainer];

    // CONTENEDOR INTERNO PARA ORGANIZAR ELEMENTOS
    UIView *row = [[UIView alloc] initWithFrame:CGRectMake(10, 0, rowContainer.bounds.size.width - 20, rowHeight)];
    row.backgroundColor = UIColor.clearColor;
    [rowContainer addSubview:row];

    // MODIFICADO: ICONO DE ADVERTENCIA AHORA A LA IZQUIERDA
    UIImageView *warningIcon = nil;
    if (isWarning && self.iconWarning) {
        warningIcon = [[UIImageView alloc] initWithImage:[self.iconWarning imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate]];
        warningIcon.tintColor = [UIColor colorWithRed:1.0 green:0.65 blue:0.1 alpha:1.0];
        warningIcon.frame = CGRectMake(8, (rowHeight - 16) / 2, 16, 16);
        warningIcon.contentMode = UIViewContentModeScaleAspectFit;
        warningIcon.userInteractionEnabled = YES;
        [row addSubview:warningIcon];

        UILongPressGestureRecognizer *lp = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(handleWarningPress:)];
        lp.minimumPressDuration = 0.2;
        [warningIcon addGestureRecognizer:lp];
    }

    // LABEL (AHORA DESPUÉS DEL ICONO DE ADVERTENCIA)
    CGFloat labelX = isWarning ? 30 : 0; // Espacio para el icono de advertencia
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(labelX, 0, row.frame.size.width - labelX - checkboxSize - spacing, rowHeight)];
    label.text = text;
    label.textColor = [UIColor colorWithRed:1.0 green:1.0 blue:1.0 alpha:0.9]; // Texto más visible
    label.font = self.fontRegular;
    [row addSubview:label];

    // CHECKBOX REDONDEADO COMPLETO (180°) - AHORA EN LA ESQUINA DERECHA
    CGFloat checkboxX = row.frame.size.width - checkboxSize;
    UIView *box = [[UIView alloc] initWithFrame:CGRectMake(checkboxX, (rowHeight - checkboxSize) / 2, checkboxSize, checkboxSize)];
    box.backgroundColor = *enabledRef ? self.panelAccentColor : [UIColor colorWithRed:35/255.0 green:42/255.0 blue:50/255.0 alpha:1.0];
    box.clipsToBounds = YES;
    box.tag = 8000;
    
    // APLICAR ESQUINAS REDONDEADAS COMPLETAS AL CHECKBOX (180°)
    applyRoundedCornersToView(box, checkboxSize / 2.0); // 180° = tamaño/2
    
    // EFECTO GLOW DINÁMICO PARA EL CHECKBOX
    if (*enabledRef) {
        updateGlowEffectForView(box, self.panelAccentColor, YES);
    } else {
        updateGlowEffectForView(box, self.panelAccentColor, NO);
    }
    
    // EFECTO DE SOMBRA PARA EL CHECKBOX
    box.layer.shadowColor = UIColor.blackColor.CGColor;
    box.layer.shadowOffset = CGSizeMake(0, 1);
    box.layer.shadowOpacity = 0.3;
    box.layer.shadowRadius = 1;
    [row addSubview:box];

    UIImageView *check = [[UIImageView alloc] initWithImage:[self.iconCheck imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate]];
    check.frame = CGRectMake(4, 4, checkboxSize - 8, checkboxSize - 8);
    check.contentMode = UIViewContentModeScaleAspectFit;
    check.tintColor = [UIColor whiteColor];
    check.hidden = !(*enabledRef);
    [box addSubview:check];

    // BOTÓN PARA TOGGLE
    UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, rowContainer.frame.size.width, rowHeight)];
    btn.backgroundColor = [UIColor clearColor];
    [btn addAction:[UIAction actionWithHandler:^(__kindof UIAction * _Nonnull action) {
        *enabledRef = !(*enabledRef);
        
        // ANIMACIÓN SUAVE PARA EL CAMBIO DE ESTADO
        [UIView animateWithDuration:0.2 animations:^{
            if (*enabledRef) {
                // EFECTOS CUANDO SE ACTIVA - CON GLOW
                box.backgroundColor = self.panelAccentColor;
                rowContainer.backgroundColor = [UIColor colorWithRed:30/255.0 green:37/255.0 blue:45/255.0 alpha:1.0];
                rowContainer.layer.borderColor = self.panelAccentColor.CGColor;
                rowContainer.transform = CGAffineTransformMakeScale(1.02, 1.02);
                
                // ACTIVAR EFECTO GLOW
                updateGlowEffectForView(box, self.panelAccentColor, YES);
                
            } else {
                // EFECTOS CUANDO SE DESACTIVA - SIN GLOW
                box.backgroundColor = [UIColor colorWithRed:35/255.0 green:42/255.0 blue:50/255.0 alpha:1.0];
                rowContainer.backgroundColor = [UIColor colorWithRed:25/255.0 green:32/255.0 blue:40/255.0 alpha:1.0];
                rowContainer.layer.borderColor = [UIColor colorWithRed:40/255.0 green:47/255.0 blue:55/255.0 alpha:1.0].CGColor;
                rowContainer.transform = CGAffineTransformIdentity;
                
                // DESACTIVAR EFECTO GLOW
                updateGlowEffectForView(box, self.panelAccentColor, NO);
            }
        } completion:^(BOOL finished) {
            // Animación de rebote al finalizar
            [UIView animateWithDuration:0.1 animations:^{
                rowContainer.transform = CGAffineTransformIdentity;
            }];
        }];
        
        // ANIMACIÓN DEL CHECKMARK
        [UIView transitionWithView:check duration:0.2 options:UIViewAnimationOptionTransitionCrossDissolve animations:^{
            check.hidden = !(*enabledRef);
        } completion:nil];
        
        // [self playActivationSound]; - Removed by user request
    }] forControlEvents:UIControlEventTouchUpInside];
    [rowContainer addSubview:btn];

    *currentY += rowHeight + 8;
}

- (void)handleWarningPress:(UILongPressGestureRecognizer *)gesture {
    if (gesture.state == UIGestureRecognizerStateBegan) {
        UIView *icon = gesture.view;
        
        UILabel *tooltipLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        tooltipLabel.backgroundColor = [UIColor colorWithRed:1.0 green:0.65 blue:0.1 alpha:1.0];
        tooltipLabel.textColor = UIColor.blackColor;
        tooltipLabel.font = [UIFont systemFontOfSize:11 weight:UIFontWeightSemibold];
        tooltipLabel.textAlignment = NSTextAlignmentCenter;
        tooltipLabel.layer.masksToBounds = YES;
        tooltipLabel.numberOfLines = 0;
        tooltipLabel.text = @"Use with caution";
        tooltipLabel.alpha = 0.0;
        tooltipLabel.tag = 99999;
        
        // Aplicar esquinas redondeadas
        tooltipLabel.layer.cornerRadius = 6;
        tooltipLabel.clipsToBounds = YES;

        UIWindow *mainWindow = icon.window;
        if (!mainWindow) return;
        [mainWindow addSubview:tooltipLabel];

        CGRect iconFrameInWindow = [icon convertRect:icon.bounds toView:mainWindow];
        CGSize textSize = [tooltipLabel sizeThatFits:CGSizeMake(200, CGFLOAT_MAX)];
        CGFloat tooltipWidth = textSize.width + 12;
        CGFloat tooltipHeight = textSize.height + 6;

        tooltipLabel.frame = CGRectMake(
            CGRectGetMidX(iconFrameInWindow) - tooltipWidth / 2,
            CGRectGetMinY(iconFrameInWindow) - tooltipHeight - 4,
            tooltipWidth,
            tooltipHeight
        );

        [UIView animateWithDuration:0.15 animations:^{
            tooltipLabel.alpha = 1.0;
        }];
    } else if (gesture.state == UIGestureRecognizerStateEnded ||
               gesture.state == UIGestureRecognizerStateCancelled ||
               gesture.state == UIGestureRecognizerStateFailed) {
        UIView *icon = gesture.view;
        UIWindow *mainWindow = icon.window;
        if (!mainWindow) return;

        UIView *tooltipLabel = [mainWindow viewWithTag:99999];
        if (tooltipLabel) {
            [UIView animateWithDuration:0.15 animations:^{
                tooltipLabel.alpha = 0.0;
            } completion:^(BOOL finished) {
                [tooltipLabel removeFromSuperview];
            }];
        }
    }
}

#pragma mark - Slider con el Diseño Exacto del Segundo Proyecto CORREGIDO

- (void)addSliderTo:(UIView *)parent
               atY:(CGFloat *)currentY
          withText:(NSString *)text
         valueRef:(float *)valueRef
               min:(float)min
               max:(float)max
          onChange:(void (^)(float newValue))onChange {

    CGFloat contentX = 14;
    CGFloat sliderWidth = parent.bounds.size.width - contentX * 2;
    CGFloat sliderHeight = 36;
    CGFloat thumbRadius = 9.0;
    CGFloat trackOffset = 4.0;

    // Asegurar que el valor por defecto sea 1.0 si es el slider de transparencia
    if ([text isEqualToString:@"Menu Transparency"] && *valueRef == 0) {
        *valueRef = 1.0f;
        self.menuAlpha = 1.0f;
        if (self.menuContainer) {
            self.menuContainer.alpha = 1.0f;
        }
    }

    UILabel *sliderLabel = [[UILabel alloc] initWithFrame:CGRectMake(contentX, *currentY, sliderWidth, 20)];
    NSString *labelText = [NSString stringWithFormat:@"%@ %.1f×", text, *valueRef];
    NSMutableAttributedString *attr = [[NSMutableAttributedString alloc] initWithString:labelText];
    NSRange range = [labelText rangeOfString:[NSString stringWithFormat:@"%.1f×", *valueRef]];
    if (range.location != NSNotFound) {
        [attr addAttribute:NSForegroundColorAttributeName
                     value:self.panelAccentColor
                     range:range];
    }
    sliderLabel.attributedText = attr;
    sliderLabel.font = self.fontRegular;
    sliderLabel.textColor = [UIColor colorWithRed:0.7 green:0.7 blue:0.7 alpha:1.0];
    [parent addSubview:sliderLabel];
    *currentY += 10 + 5;

    UIView *sliderContainer = [[UIView alloc] initWithFrame:CGRectMake(contentX, *currentY, sliderWidth, sliderHeight)];
    sliderContainer.backgroundColor = UIColor.clearColor;
    sliderContainer.tag = 9000 + (int)self.sliderContainers.count; // Tag único
    [parent addSubview:sliderContainer];
    
    // Agregar a la lista de sliders para actualización
    [self.sliderContainers addObject:sliderContainer];

    UIView *track = [[UIView alloc] initWithFrame:CGRectMake(thumbRadius - trackOffset, sliderHeight / 2 - 1.5, sliderWidth - thumbRadius * 2 + trackOffset * 2, 3)];
    track.backgroundColor = [UIColor colorWithRed:0.15 green:0.15 blue:0.15 alpha:1.0];
    track.layer.cornerRadius = 1.5;
    [sliderContainer addSubview:track];

    UIView *fill = [[UIView alloc] initWithFrame:CGRectMake(track.frame.origin.x, track.frame.origin.y, 0, 3)];
    fill.backgroundColor = self.panelAccentColor;
    fill.layer.cornerRadius = 1.5;
    fill.tag = 7000; // Tag específico para fill
    [sliderContainer addSubview:fill];

    UIView *thumb = [[UIView alloc] initWithFrame:CGRectMake(0, 0, thumbRadius * 2, thumbRadius * 2)];
    thumb.backgroundColor = UIColor.clearColor;
    thumb.layer.cornerRadius = thumbRadius;
    thumb.layer.borderColor = self.panelAccentColor.CGColor;
    thumb.layer.borderWidth = 6.0;
    thumb.tag = 7001; // Tag específico para thumb
    [sliderContainer addSubview:thumb];

    float initialPercent = (*valueRef - min) / (max - min);
    CGFloat initialX = track.frame.origin.x + initialPercent * track.frame.size.width;
    thumb.center = CGPointMake(initialX, sliderHeight / 2);

    void (^updateSlider)(float, BOOL) = ^(float value, BOOL animated) {
        float percent = (value - min) / (max - min);
        CGFloat x = track.frame.origin.x + percent * track.frame.size.width;

        void (^applyChanges)(void) = ^{
            thumb.center = CGPointMake(x, sliderHeight / 2);
            CGFloat fillWidth = x - track.frame.origin.x - thumb.layer.borderWidth;
            if (fillWidth < 0) fillWidth = 0;
            fill.frame = CGRectMake(track.frame.origin.x, track.frame.origin.y, fillWidth, 3);
        };

        if (animated) {
            [UIView animateWithDuration:0.25 animations:applyChanges];
        } else {
            applyChanges();
        }

        NSString *newLabel = [NSString stringWithFormat:@"%@ %.1f×", text, value];
        NSMutableAttributedString *newAttr = [[NSMutableAttributedString alloc] initWithString:newLabel];
        NSRange r = [newLabel rangeOfString:[NSString stringWithFormat:@"%.1f×", value]];
        if (r.location != NSNotFound) {
            [newAttr addAttribute:NSForegroundColorAttributeName
                            value:self.panelAccentColor
                            range:r];
        }
        sliderLabel.attributedText = newAttr;
        sliderLabel.textColor = [UIColor colorWithRed:0.7 green:0.7 blue:0.7 alpha:1.0];
    };

    updateSlider(*valueRef, NO);

    UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] init];
    pan.cancelsTouchesInView = NO;
    [thumb addGestureRecognizer:pan];

    SEL sel_addBlock = sel_registerName("addTargetBlock:");
    SEL sel_handle = sel_registerName("_handleBlock:");

    static dispatch_once_t once;
    dispatch_once(&once, ^{
        IMP imp_addBlock = imp_implementationWithBlock(^void(id self, void (^block)(UIGestureRecognizer *)) {
            objc_setAssociatedObject(self, "block", block, OBJC_ASSOCIATION_COPY_NONATOMIC);
            ((void (*)(id, SEL, id, SEL))objc_msgSend)(self, sel_registerName("addTarget:action:"), self, sel_handle);
        });

        IMP imp_handle = imp_implementationWithBlock(^void(id self, UIGestureRecognizer *gesture) {
            void (^block)(UIGestureRecognizer *) = objc_getAssociatedObject(self, "block");
            if (block) block(gesture);
        });

        class_addMethod([UIGestureRecognizer class], sel_addBlock, imp_addBlock, "v@:@");
        class_addMethod([UIGestureRecognizer class], sel_handle, imp_handle, "v@:@");
    });

    ((void (*)(id, SEL, id))objc_msgSend)(pan, sel_addBlock, ^(UIGestureRecognizer *gesture) {
        CGPoint location = [gesture locationInView:sliderContainer];
        float percent = (location.x - track.frame.origin.x) / track.frame.size.width;
        percent = fminf(fmaxf(percent, 0.0), 1.0);
        float newValue = roundf((min + percent * (max - min)) * 10.0f) / 10.0f;
        *valueRef = newValue;
        updateSlider(newValue, YES);
        if (onChange) onChange(newValue);
    });

    *currentY += sliderHeight + 3;
}

#pragma mark - ComboBox Funcional

- (void)addComboBoxTo:(UIView *)parent atY:(CGFloat *)currentY withTitle:(NSString *)title options:(NSArray<NSString *> *)options selectedIndex:(int *)selectedIndex hasWarning:(NSArray<NSNumber *> *)warnings action:(void (^)(int))onSelect {
    CGFloat padding = 14, rowHeight = 34, spacing = 5, titleHeight = 20;
    CGFloat width = parent.bounds.size.width - padding * 2;

    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(padding, *currentY, width, titleHeight)];
    titleLabel.text = title;
    titleLabel.textColor = [UIColor colorWithRed:0.7 green:0.7 blue:0.7 alpha:1.0];
    titleLabel.font = self.fontRegular;
    [parent addSubview:titleLabel];
    *currentY += titleHeight + spacing;

    UIView *container = [[UIView alloc] initWithFrame:CGRectMake(padding, *currentY, width, rowHeight)];
    container.backgroundColor = [UIColor colorWithRed:25/255.0 green:32/255.0 blue:40/255.0 alpha:1.0];
    container.clipsToBounds = YES;
    // CAMBIADO: Ahora usa esquinas redondeadas en lugar de corte diagonal
    applyRoundedCornersToView(container, 8.0);
    [parent addSubview:container];

    BOOL hasWarn = [warnings[*selectedIndex] boolValue];
    CGFloat iconSize = 18;
    CGFloat labelStartX = 10;

    UIImageView *warnIcon = nil;
    if (hasWarn) {
        UIImage *iconImage = [self.iconWarning imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
        warnIcon = [[UIImageView alloc] initWithImage:iconImage];
        warnIcon.tintColor = [UIColor colorWithRed:1.0 green:0.65 blue:0.1 alpha:1.0];
        warnIcon.frame = CGRectMake(10, (rowHeight - iconSize) / 2, iconSize, iconSize);
        warnIcon.tag = 9002;
        warnIcon.userInteractionEnabled = YES;
        [container addSubview:warnIcon];

        labelStartX = 10 + iconSize + 6;
        
        UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(handleWarningPress:)];
        [warnIcon addGestureRecognizer:longPress];
    }

    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(labelStartX, 0, width - labelStartX - 36, rowHeight)];
    label.text = options[*selectedIndex];
    label.textColor = [UIColor colorWithRed:0.7 green:0.7 blue:0.7 alpha:1.0];
    label.font = self.fontRegular;
    label.tag = 9001;
    label.userInteractionEnabled = NO;
    [container addSubview:label];

    UIImageView *arrowIcon = [[UIImageView alloc] initWithImage:[self.arrowDown imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate]];
    arrowIcon.tintColor = self.panelAccentColor;
    arrowIcon.frame = CGRectMake(width - 24, (rowHeight - 18) / 2, 18, 18);
    arrowIcon.contentMode = UIViewContentModeScaleAspectFit;
    arrowIcon.tag = 9003;
    arrowIcon.userInteractionEnabled = NO;
    [container addSubview:arrowIcon];

    // Overlay para el dropdown
    _a9DkPq7LsTv0 *overlay = [[_a9DkPq7LsTv0 alloc] initWithFrame:mainWindow.bounds];
    overlay.backgroundColor = UIColor.clearColor;
    overlay.userInteractionEnabled = YES;
    overlay.layer.zPosition = 15000;
    overlay.hidden = YES;
    overlay.tag = 100000;
    [mainWindow addSubview:overlay];

    UIView *header = [self.contentView viewWithTag:9999];
    overlay._xR3mZ28JqU1o = @[header, container];

    CGFloat dropdownHeight = options.count * rowHeight;
    CGFloat maxVisibleHeight = 4 * rowHeight;

    UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:CGRectZero];
    scrollView.backgroundColor = [UIColor colorWithRed:25/255.0 green:32/255.0 blue:40/255.0 alpha:1.0];
    scrollView.scrollEnabled = YES;
    scrollView.alwaysBounceVertical = YES;
    scrollView.showsVerticalScrollIndicator = YES; // MOSTRAR barra de desplazamiento
    scrollView.contentSize = CGSizeMake(width, dropdownHeight);
    scrollView.clipsToBounds = NO;

    NSMutableArray<UIButton *> *itemButtons = [NSMutableArray array];

    for (int i = 0; i < options.count; i++) {
        UIButton *item = [[UIButton alloc] initWithFrame:CGRectMake(0, i * rowHeight, width, rowHeight)];
        [item setTitle:options[i] forState:UIControlStateNormal];
        [item setTitleColor:[UIColor colorWithRed:0.85 green:0.85 blue:0.85 alpha:1.0] forState:UIControlStateNormal];
        item.titleLabel.font = self.fontRegular;
        item.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        item.backgroundColor = [UIColor clearColor];

        if ([warnings[i] boolValue]) {
            UIImageView *wIcon = [[UIImageView alloc] initWithImage:[self.iconWarning imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate]];
            wIcon.tintColor = [UIColor colorWithRed:1.0 green:0.65 blue:0.1 alpha:1.0];
            wIcon.frame = CGRectMake(10, (rowHeight - 18) / 2, 18, 18);
            wIcon.contentMode = UIViewContentModeScaleAspectFit;
            [item addSubview:wIcon];

            item.titleEdgeInsets = UIEdgeInsetsMake(0, 10 + 18 + 6, 0, 0);

            UILongPressGestureRecognizer *press = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(handleWarningPress:)];
            [wIcon addGestureRecognizer:press];
            wIcon.userInteractionEnabled = YES;
        } else {
            item.titleEdgeInsets = UIEdgeInsetsMake(0, 12, 0, 0);
        }

        [item addTarget:self action:@selector(comboItemTouchDown:) forControlEvents:UIControlEventTouchDown];
        [item addTarget:self action:@selector(comboItemTouchUp:) forControlEvents:UIControlEventTouchUpInside];
        [item addTarget:self action:@selector(comboItemTouchUp:) forControlEvents:UIControlEventTouchUpOutside];

        [scrollView addSubview:item];
        [itemButtons addObject:item];

        if (i < options.count - 1) {
            UIView *divider = [[UIView alloc] initWithFrame:CGRectMake(12, (i + 1) * rowHeight - 0.5, width - 24, 0.5)];
            divider.backgroundColor = [UIColor colorWithRed:0.25 green:0.25 blue:0.25 alpha:0.6];
            [scrollView addSubview:divider];
        }
    }

    UIView *scrollContainer = [[UIView alloc] initWithFrame:CGRectZero];
    scrollContainer.clipsToBounds = YES;
    scrollContainer.backgroundColor = scrollView.backgroundColor;
    scrollContainer.alpha = 0.0;
    [scrollContainer addSubview:scrollView];
    [overlay addSubview:scrollContainer];

    __weak UIView *weakScrollContainer = scrollContainer;

    for (int i = 0; i < itemButtons.count; i++) {
        UIButton *item = itemButtons[i];
        [item addAction:[UIAction actionWithHandler:^(__kindof UIAction * _Nonnull action) {
            *selectedIndex = i;
            label.text = options[i];
            
            BOOL hasNewWarn = [warnings[i] boolValue];

            // Remove ícono antiguo si necesario
            UIImageView *existingWarn = [container viewWithTag:9002];
            if (existingWarn) {
                [existingWarn removeFromSuperview];
            }

            // Recria si necesario
            if (hasNewWarn) {
                UIImage *iconImage = [self.iconWarning imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
                UIImageView *newWarn = [[UIImageView alloc] initWithImage:iconImage];
                newWarn.tintColor = [UIColor colorWithRed:1.0 green:0.65 blue:0.1 alpha:1.0];
                newWarn.frame = CGRectMake(10, (rowHeight - 18) / 2, 18, 18);
                newWarn.tag = 9002;
                newWarn.userInteractionEnabled = YES;
                [container addSubview:newWarn];

                UILongPressGestureRecognizer *press = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(handleWarningPress:)];
                [newWarn addGestureRecognizer:press];
            }

            // Ajusta la posición del label
            CGFloat labelStartX = hasNewWarn ? (10 + 18 + 6) : 10;
            label.frame = CGRectMake(labelStartX, 0, width - labelStartX - 36, rowHeight);

            if (onSelect) onSelect(i);

            [UIView animateWithDuration:0.25 animations:^{
                weakScrollContainer.alpha = 0.0;
                arrowIcon.transform = CGAffineTransformIdentity;
            } completion:^(BOOL finished) {
                overlay.hidden = YES;
            }];
        }] forControlEvents:UIControlEventTouchUpInside];
    }

    UITapGestureRecognizer *closeTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(closeOpenComboFromTap:)];
    closeTap.delegate = self;
    [overlay addGestureRecognizer:closeTap];
    overlay.accessibilityElements = @[container, scrollContainer];

    __block BOOL isAnimatingDropdown = NO;

    UIButton *tapBtn = [[UIButton alloc] initWithFrame:container.bounds];
    tapBtn.backgroundColor = UIColor.clearColor;

    [tapBtn addAction:[UIAction actionWithHandler:^(__kindof UIAction * _Nonnull action) {
        if (isAnimatingDropdown) return;

        BOOL isOpen = scrollContainer.alpha > 0.1;
        if (isOpen) {
            isAnimatingDropdown = YES;
            [UIView animateWithDuration:0.25 animations:^{
                scrollContainer.alpha = 0.0;
                arrowIcon.transform = CGAffineTransformIdentity;
            } completion:^(BOOL finished) {
                overlay.hidden = YES;
                isAnimatingDropdown = NO;
            }];
        } else {
            // Cerrar otros combos abiertos
            for (UIView *v in mainWindow.subviews) {
                if (v.tag == 100000 && v != overlay) v.hidden = YES;
            }

            CGRect containerInWindow = [container convertRect:container.bounds toView:nil];
            CGFloat screenHeight = UIScreen.mainScreen.bounds.size.height;
            BOOL dropdownShouldOpenUp = CGRectGetMaxY(containerInWindow) + rowHeight + spacing + MIN(dropdownHeight, maxVisibleHeight) > screenHeight;

            CGFloat dropdownY = dropdownShouldOpenUp
                ? containerInWindow.origin.y - MIN(dropdownHeight, maxVisibleHeight) - spacing
                : containerInWindow.origin.y + rowHeight + spacing;

            CGFloat visibleHeight = MIN(dropdownHeight, maxVisibleHeight);
            scrollContainer.frame = CGRectMake(containerInWindow.origin.x, dropdownY, width, visibleHeight);
            scrollView.frame = CGRectMake(0, 0, width, visibleHeight);
            overlay.hidden = NO;
            scrollContainer.userInteractionEnabled = NO;
            isAnimatingDropdown = YES;

            [UIView animateWithDuration:0.25 animations:^{
                scrollContainer.alpha = 1.0;
                arrowIcon.transform = CGAffineTransformMakeRotation(M_PI);
                // CAMBIADO: Ahora usa esquinas redondeadas en lugar de corte diagonal
                applyRoundedCornersToView(scrollContainer, 8.0);
            } completion:^(BOOL finished) {
                scrollContainer.userInteractionEnabled = YES;
                isAnimatingDropdown = NO;
            }];
        }
    }] forControlEvents:UIControlEventTouchUpInside];
    [container addSubview:tapBtn];

    *currentY += rowHeight + 1;
}

- (void)comboItemTouchDown:(UIButton *)btn {
    btn.backgroundColor = [UIColor colorWithRed:0.3 green:0.3 blue:0.3 alpha:0.3];
}

- (void)comboItemTouchUp:(UIButton *)btn {
    btn.backgroundColor = [UIColor clearColor];
}

- (void)closeOpenComboFromTap:(UITapGestureRecognizer *)tap {
    UIView *overlay = tap.view;
    NSArray *refs = overlay.accessibilityElements;
    if (refs.count < 2) return;

    UIView *comboContainer = refs[0];
    UIView *scrollContainer = refs[1];
    
    CGPoint location = [tap locationInView:mainWindow];

    if (![comboContainer pointInside:[mainWindow convertPoint:location toView:comboContainer] withEvent:nil] &&
        ![scrollContainer pointInside:[mainWindow convertPoint:location toView:scrollContainer] withEvent:nil]) {

        [UIView animateWithDuration:0.25 animations:^{
            scrollContainer.alpha = 0.0;
            scrollContainer.transform = CGAffineTransformIdentity;
        } completion:^(BOOL finished) {
            overlay.hidden = YES;
        }];

        UIImageView *arrow = [comboContainer viewWithTag:9003];
        if (arrow) arrow.transform = CGAffineTransformIdentity;
    }
}

#pragma mark - UIGestureRecognizerDelegate

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch {
    if ([gestureRecognizer.view isKindOfClass:[_a9DkPq7LsTv0 class]]) {
        _a9DkPq7LsTv0 *overlay = (_a9DkPq7LsTv0 *)gestureRecognizer.view;
        CGPoint location = [touch locationInView:overlay];
        for (UIView *view in overlay._xR3mZ28JqU1o) {
            if (view && [view window]) {
                CGPoint pointInView = [overlay convertPoint:location toView:view];
                if ([view pointInside:pointInView withEvent:nil]) {
                    return NO;
                }
            }
        }
    }
    return YES;
}

#pragma mark - Event Handlers

- (void)sliderValueChanged:(UISlider *)slider {
    Vars.AimSpeed = slider.value;
}

#pragma mark - CORREGIDO: Sistema de movimiento SOLO desde el header

- (void)handlePan:(UIPanGestureRecognizer *)gesture {
    if (!MenDeal) return;
    
    CGPoint globalTouch = [gesture locationInView:mainWindow];

    if (gesture.state == UIGestureRecognizerStateBegan) {
        self.initialTouchPoint = globalTouch;
        self.menuStartCenter = self.menuContainer.center;
    } else if (gesture.state == UIGestureRecognizerStateChanged) {
        CGFloat dx = globalTouch.x - self.initialTouchPoint.x;
        CGFloat dy = globalTouch.y - self.initialTouchPoint.y;
        CGPoint newCenter = CGPointMake(self.menuContainer.center.x + dx, self.menuContainer.center.y + dy);
        
        // Limitar el movimiento dentro de los bordes de la pantalla
        CGFloat menuWidth = self.menuContainer.frame.size.width;
        CGFloat menuHeight = self.menuContainer.frame.size.height;
        
        newCenter.x = MAX(menuWidth/2, MIN(newCenter.x, kWidth - menuWidth/2));
        newCenter.y = MAX(menuHeight/2, MIN(newCenter.y, kHeight - menuHeight/2));
        
        self.menuContainer.center = newCenter;
        self.initialTouchPoint = globalTouch;

        // Actualizar posición de comboboxes abiertos
        for (UIView *overlay in mainWindow.subviews) {
            if (overlay.tag == 100000 && !overlay.hidden) {
                NSArray *refs = overlay.accessibilityElements;
                if (refs.count >= 2) {
                    UIView *comboContainer = refs[0];
                    UIView *dropdown = refs[1];
                    CGRect containerInWindow = [comboContainer convertRect:comboContainer.bounds toView:mainWindow];
                    dropdown.frame = CGRectMake(containerInWindow.origin.x,
                                                containerInWindow.origin.y + comboContainer.frame.size.height + 2,
                                                dropdown.frame.size.width,
                                                dropdown.frame.size.height);
                }
            }
        }
    }
}

#pragma mark - Main Implementation

+ (void)load {
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        mainWindow = [UIApplication sharedApplication].keyWindow;
        extraInfo = [Khanhios new];
        
        BOOL connectionValid = YES /* [extraInfo verifyServerConnection] - Removed by user request */;
        
        if (!connectionValid) {
            [extraInfo forceCloseApp];
            return;
        }
        
        static bool sdkInitialized = false;
        if (!sdkInitialized) {
            game_sdk->init();
            sdkInitialized = true;
        }
        
        [extraInfo setupDisplayLink];
        [extraInfo initTapGes];
        [extraInfo startPeriodicConnectionCheck];
    });

void* address[] = {
       (void*)getRealOffset(ENCRYPTOFFSET("")), 
        (void*)getRealOffset(ENCRYPTOFFSET("")), 

(void*)getRealOffset(ENCRYPTOFFSET("")),

(void*)getRealOffset(ENCRYPTOFFSET("")),

(void*)getRealOffset(ENCRYPTOFFSET(""))
    };

    void* function[] = {
        (void*)Desactivo,
        (void*)Desactivo,
        (void*)Desactivo,
        (void*)Desactivo,
        (void*)Desactivo
    };
    satoo(address, function, 5);

}

- (void)setupDisplayLink {
    self.displayLink = [CADisplayLink displayLinkWithTarget:self selector:@selector(updateMenu)];
    [self.displayLink addToRunLoop:[NSRunLoop mainRunLoop] forMode:NSRunLoopCommonModes];
}

- (void)updateMenu {
    self.menuContainer.hidden = !MenDeal;
    get_players();
}

- (void)startPeriodicConnectionCheck {
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(30 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        if (NO) { // verifyServerConnection removed by user request
            [self forceCloseApp];
        } else {
            [self startPeriodicConnectionCheck];
        }
    });
}

- (void)initTapGes {
    // Gesto 1: 2 toques con 3 dedos → Abrir menú
    UITapGestureRecognizer *tap1 = [[UITapGestureRecognizer alloc] init];
    tap1.numberOfTapsRequired = 2;
    tap1.numberOfTouchesRequired = 3;
    [mainWindow addGestureRecognizer:tap1];
    [tap1 addTarget:self action:@selector(openMenu)];
    
    // Gesto 2: 2 toques con 2 dedos → Cerrar menú  
    UITapGestureRecognizer *tap2 = [[UITapGestureRecognizer alloc] init];
    tap2.numberOfTapsRequired = 2;
    tap2.numberOfTouchesRequired = 2;
    [mainWindow addGestureRecognizer:tap2];
    [tap2 addTarget:self action:@selector(closeMenu)];
}

- (void)openMenu {
    if (!self.menuContainer) {
        [self setupMenu];
    }
    
    MenDeal = true;
    // [self playActivationSound]; - Removed by user request
}

- (void)closeMenu {
    MenDeal = false;
    // [self playDeactivationSound]; - Removed by user request
}

- (void)dealloc {
    [self.displayLink invalidate];
    self.displayLink = nil;
}

@end