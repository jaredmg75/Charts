//
//  LineChart2ViewController.m
//  ChartsDemo
//
//  Copyright 2015 Daniel Cohen Gindi & Philipp Jahoda
//  A port of MPAndroidChart for iOS
//  Licensed under Apache License 2.0
//
//  https://github.com/danielgindi/Charts
//

#import "LineChart2ViewController.h"
#import "ChartsDemo_iOS-Swift.h"

@interface LineChart2ViewController () <ChartViewDelegate, IChartAxisValueFormatter>

@property (nonatomic, strong) IBOutlet LineChartView *chartView;
@property (nonatomic, strong) IBOutlet UISlider *sliderX;
@property (nonatomic, strong) IBOutlet UISlider *sliderY;
@property (nonatomic, strong) IBOutlet UITextField *sliderTextX;
@property (nonatomic, strong) IBOutlet UITextField *sliderTextY;

@end

@implementation LineChart2ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.title = @"Line Chart 2";
    
    self.options = @[
                     @{@"key": @"toggleValues", @"label": @"Toggle Values"},
                     @{@"key": @"toggleFilled", @"label": @"Toggle Filled"},
                     @{@"key": @"toggleCircles", @"label": @"Toggle Circles"},
                     @{@"key": @"toggleCubic", @"label": @"Toggle Cubic"},
                     @{@"key": @"toggleHorizontalCubic", @"label": @"Toggle Horizontal Cubic"},
                     @{@"key": @"toggleStepped", @"label": @"Toggle Stepped"},
                     @{@"key": @"toggleHighlight", @"label": @"Toggle Highlight"},
                     @{@"key": @"animateX", @"label": @"Animate X"},
                     @{@"key": @"animateY", @"label": @"Animate Y"},
                     @{@"key": @"animateXY", @"label": @"Animate XY"},
                     @{@"key": @"saveToGallery", @"label": @"Save to Camera Roll"},
                     @{@"key": @"togglePinchZoom", @"label": @"Toggle PinchZoom"},
                     @{@"key": @"toggleAutoScaleMinMax", @"label": @"Toggle auto scale min/max"},
                     @{@"key": @"toggleData", @"label": @"Toggle Data"},
                     ];
    
    _chartView.delegate = self;
    
    _chartView.chartDescription.enabled = NO;
    
    _chartView.dragEnabled = YES;
    [_chartView setScaleEnabled:YES];
    _chartView.drawGridBackgroundEnabled = NO;
    _chartView.pinchZoomEnabled = YES;
    
    _chartView.backgroundColor = UIColor.blackColor;
    [_chartView.legend setEnabled:NO];
    
    ChartXAxis *xAxis = _chartView.xAxis;
    xAxis.labelFont = [UIFont systemFontOfSize:11.f];
    xAxis.labelTextColor = UIColor.whiteColor;
    xAxis.drawGridLinesEnabled = NO;
    xAxis.axisLineWidth = 6;
    xAxis.drawAxisLineEnabled = YES;
    xAxis.axisLineDashLengths = @[@1, @10];
    xAxis.labelPosition = XAxisLabelPositionBottom;
    
    [xAxis setValueFormatter:self];
    
    ChartYAxis *leftAxis = _chartView.leftAxis;
    leftAxis.drawGridLinesEnabled = NO;
    leftAxis.drawZeroLineEnabled = NO;
    leftAxis.granularityEnabled = NO;
    leftAxis.drawLabelsEnabled = NO;
    leftAxis.drawAxisLineEnabled = YES;
    leftAxis.axisLineWidth = 6;
    leftAxis.drawAxisLineEnabled = YES;
    leftAxis.axisLineDashLengths = @[@1, @10];

    ChartYAxis *rightAxis = _chartView.rightAxis;
    rightAxis.drawGridLinesEnabled = NO;
    rightAxis.drawAxisLineEnabled = NO;
    rightAxis.drawZeroLineEnabled = NO;
    rightAxis.granularityEnabled = NO;
    rightAxis.drawLabelsEnabled = NO;
    
    BalloonMarker *marker = [[BalloonMarker alloc]
                             initWithColor: UIColor.darkGrayColor
                             font: [UIFont systemFontOfSize:12.0]
                             textColor: UIColor.greenColor
                             insets: UIEdgeInsetsMake(2.0, 2.0, 2.0, 2.0)];
    marker.chartView = _chartView;
    marker.minimumSize = CGSizeMake(40.f, 20.f);
    marker.arrowSize = CGSizeMake(12.0f, 12.0f);
    
    _chartView.marker = marker;

    
    _sliderX.value = 20.0;
    _sliderY.value = 30.0;
    [self slidersValueChanged:nil];
    
    [_chartView animateWithXAxisDuration:2.5];
}

#pragma mark - IAxisValueFormatter

- (NSString *)stringForValue:(double)value
                        axis:(ChartAxisBase *)axis
{
    if (axis == _chartView.xAxis) {
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"h:mm"];
        [dateFormatter setTimeZone:[NSTimeZone timeZoneWithAbbreviation:@"UTC"]];
        NSDate *date = [[NSDate alloc] initWithTimeIntervalSince1970:value];
        return [dateFormatter stringFromDate:date];
    }
    
    return @"";
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)updateChartData
{
    if (self.shouldHideData)
    {
        _chartView.data = nil;
        return;
    }
    
    [self setDataCount:_sliderX.value + 1 range:_sliderY.value];
}

- (void)setDataCount:(int)count range:(double)range
{
    double baseDate = 1567123200;
    double secondsBetweenEntries = 86400 / count;
    
    NSMutableArray *yVals1 = [[NSMutableArray alloc] init];
    NSMutableArray *yVals2 = [[NSMutableArray alloc] init];
    NSMutableArray *yVals3 = [[NSMutableArray alloc] init];
    
    for (int i = 0; i < count; i++)
    {
        double mult = range / 2.0;
        double val = (double) (arc4random_uniform(mult)) + 50;
        double xVal = baseDate + (secondsBetweenEntries * i);
        [yVals1 addObject:[[ChartDataEntry alloc] initWithX:xVal y:val]];
    }
    
    for (int i = 0; i < count - 1; i++)
    {
        double mult = range;
        double val = (double) (arc4random_uniform(mult)) + 450;
        double xVal = baseDate + (secondsBetweenEntries * i);
        [yVals2 addObject:[[ChartDataEntry alloc] initWithX:xVal y:val]];
    }
    
    for (int i = 0; i < count; i++)
    {
        double mult = range;
        double val = (double) (arc4random_uniform(mult)) + 500;
        double xVal = baseDate + (secondsBetweenEntries * i);
        [yVals3 addObject:[[ChartDataEntry alloc] initWithX:xVal y:val]];
    }
    
//    [values addObject:[[ChartDataEntry alloc] initWithX:i y:val icon: [UIImage imageNamed:@"icon"]]];

    
    LineChartDataSet *set1 = nil, *set2 = nil, *set3 = nil;
    
    if (_chartView.data.dataSetCount > 0)
    {
        set1 = (LineChartDataSet *)_chartView.data.dataSets[0];
        set2 = (LineChartDataSet *)_chartView.data.dataSets[1];
        set3 = (LineChartDataSet *)_chartView.data.dataSets[2];
        [set1 replaceEntries:yVals1];
        [set2 replaceEntries:yVals2];
        [set3 replaceEntries:yVals3];
        [_chartView.data notifyDataChanged];
        [_chartView notifyDataSetChanged];
    }
    else
    {
        set1 = [[LineChartDataSet alloc] initWithEntries:yVals1 label:@"DataSet 1"];
        set1.axisDependency = AxisDependencyLeft;
        [set1 setColor:[UIColor colorWithRed:51/255.f green:181/255.f blue:229/255.f alpha:1.f]];
        [set1 setCircleColor:UIColor.whiteColor];
        set1.lineWidth = 2.0;
        set1.circleRadius = 3.0;
        set1.fillAlpha = 65/255.0;
        set1.fillColor = [UIColor colorWithRed:51/255.f green:181/255.f blue:229/255.f alpha:1.f];
        set1.highlightColor = [UIColor colorWithRed:244/255.f green:117/255.f blue:117/255.f alpha:1.f];
        set1.drawCircleHoleEnabled = NO;
        set1.drawValuesEnabled = NO;
        
        set2 = [[LineChartDataSet alloc] initWithEntries:yVals2 label:@"DataSet 2"];
        set2.axisDependency = AxisDependencyRight;
        [set2 setColor:UIColor.redColor];
        [set2 setCircleColor:UIColor.whiteColor];
        set2.lineWidth = 2.0;
        set2.circleRadius = 3.0;
        set2.fillAlpha = 65/255.0;
        set2.fillColor = UIColor.redColor;
        set2.highlightColor = [UIColor colorWithRed:244/255.f green:117/255.f blue:117/255.f alpha:1.f];
        set2.drawCircleHoleEnabled = NO;
        set1.drawValuesEnabled = NO;

        set3 = [[LineChartDataSet alloc] initWithEntries:yVals3 label:@"DataSet 3"];
        set3.axisDependency = AxisDependencyRight;
        [set3 setColor:UIColor.yellowColor];
        [set3 setCircleColor:UIColor.whiteColor];
        set3.lineWidth = 2.0;
        set3.circleRadius = 3.0;
        set3.fillAlpha = 65/255.0;
        set3.fillColor = [UIColor.yellowColor colorWithAlphaComponent:200/255.f];
        set3.highlightColor = [UIColor colorWithRed:244/255.f green:117/255.f blue:117/255.f alpha:1.f];
        set3.drawCircleHoleEnabled = NO;
        set1.drawValuesEnabled = NO;

        NSMutableArray *dataSets = [[NSMutableArray alloc] init];
        [dataSets addObject:set1];
        [dataSets addObject:set2];
        [dataSets addObject:set3];
        
        set1.highlightLineWidth = 2;
        set1.highlightColor = UIColor.grayColor;
        set1.drawHorizontalHighlightIndicatorEnabled = NO;
        set1.drawVerticalHighlightIndicatorEnabled = YES;
        set1.drawValuesEnabled = NO;
        
        set2.highlightLineWidth = 2;
        set2.highlightColor = UIColor.grayColor;
        set2.drawHorizontalHighlightIndicatorEnabled = NO;
        set2.drawVerticalHighlightIndicatorEnabled = YES;
        set2.drawValuesEnabled = NO;

        set3.highlightLineWidth = 2;
        set3.highlightColor = UIColor.grayColor;
        set3.drawHorizontalHighlightIndicatorEnabled = NO;
        set3.drawVerticalHighlightIndicatorEnabled = YES;
        set3.drawValuesEnabled = NO;

        LineChartData *data = [[LineChartData alloc] initWithDataSets:dataSets];
        [data setValueTextColor:UIColor.whiteColor];
        [data setValueFont:[UIFont systemFontOfSize:9.f]];
        
        _chartView.data = data;
    }
}

- (void)optionTapped:(NSString *)key
{
    if ([key isEqualToString:@"toggleFilled"])
    {
        for (id<ILineChartDataSet> set in _chartView.data.dataSets)
        {
            set.drawFilledEnabled = !set.isDrawFilledEnabled;
        }
        
        [_chartView setNeedsDisplay];
        return;
    }
    
    if ([key isEqualToString:@"toggleCircles"])
    {
        for (id<ILineChartDataSet> set in _chartView.data.dataSets)
        {
            set.drawCirclesEnabled = !set.isDrawCirclesEnabled;
        }
        
        [_chartView setNeedsDisplay];
        return;
    }
    
    if ([key isEqualToString:@"toggleCubic"])
    {
        for (id<ILineChartDataSet> set in _chartView.data.dataSets)
        {
            set.mode = set.mode == LineChartModeCubicBezier ? LineChartModeLinear : LineChartModeCubicBezier;
        }
        
        [_chartView setNeedsDisplay];
        return;
    }

    if ([key isEqualToString:@"toggleStepped"])
    {
        for (id<ILineChartDataSet> set in _chartView.data.dataSets)
        {
            switch (set.mode) {
                case LineChartModeLinear:
                case LineChartModeCubicBezier:
                case LineChartModeHorizontalBezier:
                    set.mode = LineChartModeStepped;
                    break;
                case LineChartModeStepped: set.mode = LineChartModeLinear;
            }
        }

        [_chartView setNeedsDisplay];
    }
    
    if ([key isEqualToString:@"toggleHorizontalCubic"])
    {
        for (id<ILineChartDataSet> set in _chartView.data.dataSets)
        {
            set.mode = set.mode == LineChartModeCubicBezier ? LineChartModeHorizontalBezier : LineChartModeCubicBezier;
        }
        
        [_chartView setNeedsDisplay];
        return;
    }
    
    [super handleOption:key forChartView:_chartView];
}

#pragma mark - Actions

- (IBAction)slidersValueChanged:(id)sender
{
    _sliderTextX.text = [@((int)_sliderX.value) stringValue];
    _sliderTextY.text = [@((int)_sliderY.value) stringValue];
    
    [self updateChartData];
}

#pragma mark - ChartViewDelegate

- (void)chartValueSelected:(ChartViewBase * __nonnull)chartView entry:(ChartDataEntry * __nonnull)entry highlight:(ChartHighlight * __nonnull)highlight
{
    NSLog(@"chartValueSelected");
    
//    ChartHighlight
//    [_chartView highlightValues:@[]];
    
    [_chartView centerViewToAnimatedWithXValue:entry.x yValue:entry.y axis:[_chartView.data getDataSetByIndex:highlight.dataSetIndex].axisDependency duration:1.0];
    //[_chartView moveViewToAnimatedWithXValue:entry.x yValue:entry.y axis:[_chartView.data getDataSetByIndex:dataSetIndex].axisDependency duration:1.0];
    //[_chartView zoomAndCenterViewAnimatedWithScaleX:1.8 scaleY:1.8 xValue:entry.x yValue:entry.y axis:[_chartView.data getDataSetByIndex:dataSetIndex].axisDependency duration:1.0];

}

- (void)chartValueNothingSelected:(ChartViewBase * __nonnull)chartView
{
    NSLog(@"chartValueNothingSelected");
}

@end
