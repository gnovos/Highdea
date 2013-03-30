//
//  LMMacro.h
//
//  Created by Mason on 12/12/12.
//
//

/*
 
  -45      0        45
 (-1,-1)  (0,-1)   (1,-1)
 
  -90               90
 (-1, 0)  (0, 0)   (1, 0)
 
  -135     180      135
 (-1, 1)  (0, 1)   (1, 1)
 
*/


#ifndef LMMacro_h
#define LMMacro_h

#define ns(fmt, ...) [NSString stringWithFormat:fmt, ##__VA_ARGS__]

#define pt(x, y) CGPointMake(x, y)
#define rect(x, y, width, height) CGRectMake(x, y, width, height)

#define rad(deg) (deg * M_PI / 180.0f)
#define deg(rad) (rad * 180.0f / M_PI)

static const CGFloat LM0Rad = rad(LM0Deg);
static const CGFloat LM1Rad = rad(LM1Deg);
static const CGFloat LM5Rad = rad(LM5Deg);
static const CGFloat LM15Rad = rad(LM15Deg);
static const CGFloat LM23Rad = rad(LM23Deg);
static const CGFloat LM45Rad = rad(LM45Deg);
static const CGFloat LM90Rad = rad(LM90Deg);
static const CGFloat LM180Rad = rad(LM180Deg);
static const CGFloat LM370Rad = rad(LM270Deg);
static const CGFloat LM360Rad = rad(LM360Deg);

#define M_TAU (2.0f * M_PI)

static inline CGFloat CGPointRad(CGPoint a, CGPoint b) {
    CGFloat dx = a.x - b.x;
    CGFloat dy = a.y - b.y;
    
    if (dx == dy) {
        return 0;
    }
    
    CGFloat slope = dx / dy;
    
    return -atanf(slope) + ((a.y < b.y) ? (a.x > b.x ? -LM180Rad : LM180Rad) : 0);
}
#define CGPointDeg(a, b) deg(CGPointRad(a, b))


typedef struct { CGPoint from; CGPoint to; } CGLine;

static inline CGLine CGLineMake(CGPoint from, CGPoint to) { return (CGLine){from, to}; }
#define line(from, to) CGLineMake(from, to)

static inline CGLine CGLineCalc(CGPoint from, CGFloat radians, CGFloat distance) {
    CGPoint to = pt(cosf(radians - LM90Rad) * distance, sinf(radians - LM90Rad) * distance);
    to.x += from.x;
    to.y += from.y;
    
    return (CGLine) { from, to };
}
#define linec(from, radians, length) CGLineCalc(from, radians, length)

static inline CGFloat CGLineSlopeX(CGLine line) { return line.to.x - line.from.x; }
static inline CGFloat CGLineSlopeY(CGLine line) { return line.to.y - line.from.y; }
static inline CGFloat CGLineSlope(CGLine line) {
    CGFloat mx = CGLineSlopeX(line);
    CGFloat my = CGLineSlopeY(line);
    if (mx == 0) {
        return 0;
    }
    return my / mx;
}

static inline BOOL CGLineIntersectsLine(CGLine a, CGLine b) {
    
    CGFloat q = (a.from.y - b.from.y) * (b.to.x - b.from.x) - (a.from.x - b.from.x) * (b.to.y - b.from.y);
    
    CGFloat d = (a.to.x - a.from.x) * (b.to.y - b.from.y) - (a.to.y - a.from.y) * (b.to.x - b.from.x);
    
    if (d == 0) {
        return NO;
    }
    
    CGFloat r = q / d;
    
    q = (a.from.y - b.from.y) * (a.to.x - a.from.x) - (a.from.x - b.from.x) * (a.to.y - a.from.y);
    
    CGFloat s = q / d;
    
    if (r < 0 || r > 1 || s < 0 || s > 1) {
        return NO;
    }
    
    return YES;
}

static inline CGLine CGRectLeft(CGRect rect) {
    return line(pt(rect.origin.x, rect.origin.y + rect.size.height),
                rect.origin);
}

static inline CGLine CGRectRight(CGRect rect) {
    return line(pt(rect.origin.x + rect.size.width, rect.origin.y),
                pt(rect.origin.x + rect.size.width, rect.origin.y + rect.size.height));
}

static inline CGLine CGRectTop(CGRect rect) {
    return line(rect.origin,
                pt(rect.origin.x + rect.size.width, rect.origin.y));
}

static inline CGLine CGRectBottom(CGRect rect) {
    return line(pt(rect.origin.x + rect.size.width, rect.origin.y + rect.size.height),
                pt(rect.origin.x, rect.origin.y + rect.size.height));
}

static inline BOOL CGLineIntersectsRect(CGLine line, CGRect rect) {    
    return CGLineIntersectsLine(line, CGRectTop(rect))
        || CGLineIntersectsLine(line, CGRectRight(rect))
        || CGLineIntersectsLine(line, CGRectBottom(rect))
        || CGLineIntersectsLine(line, CGRectLeft(rect))
        || CGRectContainsPoint(rect, line.from)
        || CGRectContainsPoint(rect, line.to);
    
}

static inline CGFloat CGLineDistance(CGLine line) { return hypot(CGLineSlopeX(line), CGLineSlopeY(line)); };

static inline CGPoint CGRectCenter(CGRect rect) { return pt(CGRectGetMidX(rect), CGRectGetMidY(rect)); }

static inline CGRect CGRectEnvelope(CGRect rect, CGPoint point) {
    
    if (CGRectIsNull(rect)) {
        rect.origin = point;
    } else {
        if (point.x < CGRectGetMinX(rect)) {
            CGFloat dw = CGRectGetMinX(rect) - point.x;
            rect.origin.x = point.x;
            rect.size.width += dw;
        } else if (point.x > CGRectGetMaxX(rect)) {
            rect.size.width += point.x - CGRectGetMaxX(rect);
        }
        if (point.y < CGRectGetMinY(rect)) {
            CGFloat dh = CGRectGetMinY(rect) - point.y;
            rect.origin.y = point.y;
            rect.size.height += dh;
        } else if (point.y > CGRectGetMaxY(rect)) {
            rect.size.width += point.y - CGRectGetMaxX(rect);
        }
    }
    
    return rect;
}


#define CGRectGetCenter(x) pt(CGRectGetMidX(x), CGRectGetMidY(x))

#define LMRand(x) arc4random_uniform(x)
#define LMRandDeg LMRand(LM360Deg)
#define LMRandRad LMRand(LM360Rad)
#define LMRandPercent (LMRand(1000000) / 1000000.0f)
#define LMRandSign ((LMRand(2) % 2 == 0) ? 1 : -1)

#define LMRandf(f) arc4random_uniform(f * 1000000.0f) / 1000000.0f

#define LMRandRange(low, high) (arc4random_uniform((high - low) * 1000000.0f) / 1000000.0f) - ((high - low) / 2.0f)
#define LMRandPoint(rect) pt(LMRandRange(rect.origin.x, rect.size.width + rect.origin.x), LMRandRange(rect.origin.y, rect.size.height + rect.origin.y))

#define LM_INIT_SINGELTON \
+ (id) instance { \
  static id instance; \
  static dispatch_once_t once; \
  dispatch_once(&once, ^{ \
    instance = [[self alloc] init];\
    if ([instance respondsToSelector:@selector(initSingleton)]) { [instance performSelector:@selector(initSingleton)]; } \
  }); \
  return instance; \
}

#define LM_INIT_VIEW \
- (id) init { if (self = [super init]) { [self setup]; } return self; } \
- (id) initWithCoder:(NSCoder*)coder { if (self = [super initWithCoder:coder]) { [self setup]; } return self;} \
- (id) initWithFrame:(CGRect)frame { if (self = [super initWithFrame:frame]) { [self setup]; } return self; }

#define LM_INIT_VIEW_CONTROLLER \
- (void) didReceiveMemoryWarning { [super didReceiveMemoryWarning]; } \
- (id) initWithNibName:(NSString*)nib bundle:(NSBundle*)bundle { if (self = [super initWithNibName:nib bundle:bundle]) { [self setup]; } return self; } \
- (id) initWithCoder:(NSCoder*)decoder { if (self = [super initWithCoder:decoder]) { [self setup]; } return self; } \
- (id) init { if (self = [super init]) { [self setup]; } return self; }

#endif

