//
//  ViewController.m
//  Persistence
//
//  Created by ad on 19/11/2016.
//
//  博文： https://github.com/pro648/tips/blob/master/iOS%E6%95%B0%E6%8D%AE%E6%8C%81%E4%B9%85%E5%8C%96.md

#import "ViewController.h"

@interface ViewController () <UITextViewDelegate, UITextFieldDelegate>

@property (strong, nonatomic) IBOutlet UISegmentedControl *segments;
@property (strong, nonatomic) IBOutlet UIActivityIndicatorView *spinner;
@property (strong, nonatomic) IBOutlet UIButton *spinningButton;
@property (strong, nonatomic) IBOutlet UISwitch *cSwitch;
@property (strong, nonatomic) IBOutlet UITextField *textField;
@property (strong, nonatomic) IBOutlet UIProgressView *progressBar;
@property (strong, nonatomic) IBOutlet UISlider *slider1;
@property (strong, nonatomic) IBOutlet UISlider *slider2;
@property (strong, nonatomic) IBOutlet UISlider *slider3;
@property (strong, nonatomic) IBOutlet UITextView *textBox;

@property (strong, nonatomic) NSMutableDictionary *controlState;
@property (strong, nonatomic) NSMutableDictionary *sliderValue;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Do any additional setup after loading the view, typically from a nib.
    _textField.delegate = self;
    _textBox.delegate = self;
    
    _textBox.backgroundColor = [UIColor lightGrayColor];
    _textField.placeholder = @"Text Field";
    
    _controlState = [NSMutableDictionary dictionary];
    _sliderValue = [NSMutableDictionary dictionary];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:true];
    
    // Load segmented control selection.
    NSInteger selectedSegmentIndex = [[NSUserDefaults standardUserDefaults] integerForKey:@"SelectedSegmentIndex"];
    _segments.selectedSegmentIndex = selectedSegmentIndex;
    
    if ([[NSUserDefaults standardUserDefaults] boolForKey:@"SpinnerAnimatingState"] == true)
    {
        [_spinner startAnimating];
        [_spinningButton setTitle:@"Stop Animating" forState:UIControlStateNormal];
    }
    else
    {
        [_spinner stopAnimating];
        [_spinningButton setTitle:@"Start Animating" forState:UIControlStateNormal];
    }
    
    NSArray *pathes = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, true);
    NSString *documentsDirectoryPath = [pathes firstObject];
    
    // Load data from plist
    if ([[_controlState allKeys] count] == 0)
    {
        NSString *filePath = [documentsDirectoryPath stringByAppendingPathComponent:@"componentState.plist"];
        _controlState = [NSMutableDictionary dictionaryWithContentsOfFile:filePath];
        
        [_cSwitch setOn:[[_controlState objectForKey:@"SwitchEnabledState"] boolValue]];
        _progressBar.progress = [[_controlState objectForKey:@"ProgressBarProgress"] floatValue];
        _textField.text = [_controlState objectForKey:@"TextFieldContents"];
    }
    
    // Decode objects
    if ([[_sliderValue allKeys] count] == 0)
    {
        NSMutableData *data = [[NSMutableData alloc] initWithContentsOfFile:[documentsDirectoryPath stringByAppendingPathComponent:@"ArchivedObjects"]];
        NSKeyedUnarchiver *decoder = [[NSKeyedUnarchiver alloc] initForReadingWithData:data];
        _sliderValue = [decoder decodeObjectForKey:@"SliderValues"];
        
        _slider1.value = [[_sliderValue objectForKey:@"Slider1Key"] floatValue];
        _slider2.value = [[_sliderValue objectForKey:@"Slider2Key"] floatValue];
        _slider3.value = [[_sliderValue objectForKey:@"Slider3Key"] floatValue];
    }
    
    // Read text file
    NSString *filePath = [documentsDirectoryPath stringByAppendingPathComponent:@"TextViewContents.txt"];
    NSString *textViewContents = [NSString stringWithContentsOfFile:filePath encoding:NSUTF8StringEncoding error:nil];
    
    _textBox.text = textViewContents;
}

- (IBAction)toggleSpinner:(id)sender
{
    if (_spinner.isAnimating)
    {
        [_spinner stopAnimating];
        [_spinningButton setTitle:@"Start Animating" forState:UIControlStateNormal];
    }
    else
    {
        [_spinner startAnimating];
        [_spinningButton setTitle:@"Stop Animating" forState:UIControlStateNormal];
    }
    
    [[NSUserDefaults standardUserDefaults] setBool:[_spinner isAnimating] forKey:@"SpinnerAnimatingState"];
}

- (IBAction)controlValueChanged:(id)sender
{
    if (! _controlState)
    {
        _controlState = [NSMutableDictionary dictionary];
    }
    if (! _sliderValue) {
        _sliderValue = [NSMutableDictionary dictionary];
    }
    
    if (sender == _segments)
    {
        NSInteger selectedSegment = ((UISegmentedControl *)sender).selectedSegmentIndex;
        [[NSUserDefaults standardUserDefaults] setInteger:selectedSegment forKey:@"SelectedSegmentIndex"];
    }
    else if (sender == _cSwitch)
    {
        [_controlState setValue:[NSNumber numberWithBool:_cSwitch.isOn] forKey:@"SwitchEnabledState"];
    }
    else if (sender == _textField)
    {
        [_controlState setValue:_textField.text forKey:@"TextFieldContents"];
    }
    else if (sender == _slider1)
    {
        [_sliderValue setValue:[NSNumber numberWithFloat:_slider1.value] forKey:@"Slider1Key"];
        
        // Update progress bar with slider
        [_progressBar setProgress:_slider1.value];
        [_controlState setValue:[NSNumber numberWithFloat:_progressBar.progress] forKey:@"ProgressBarProgress"];
    }
    else if (sender == _slider2)
        [_sliderValue setValue:[NSNumber numberWithFloat:_slider2.value] forKey:@"Slider2Key"];
    else if (sender == _slider3)
        [_sliderValue setValue:[NSNumber numberWithFloat:_slider3.value] forKey:@"Slider3Key"];
    else
        return ;
    
    // Save plist
    NSArray *path = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, true);
    NSString *documentDirectoryPath = [path firstObject];
    NSString *filePath = [documentDirectoryPath stringByAppendingPathComponent:@"componentState.plist"];
    [_controlState writeToFile:filePath atomically:true];
    
    // Archive object
    NSMutableData *data = [NSMutableData data];
    NSKeyedArchiver *archiver = [[NSKeyedArchiver alloc] initForWritingWithMutableData:data];
    [archiver encodeObject:_sliderValue forKey:@"SliderValues"];
    [archiver finishEncoding];
    NSString *dataPath = [documentDirectoryPath stringByAppendingPathComponent:@"ArchivedObjects"];
    [data writeToFile:dataPath atomically:true];
}

-(void)textViewDidChange:(UITextView *)textView
{
    NSString *textViewContents = textView.text;
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, true);
    NSString *documentDirectoryPath = [paths firstObject];
    NSString *filePath = [documentDirectoryPath stringByAppendingPathComponent:@"TextViewContents.txt"];
    
    [textViewContents writeToFile:filePath atomically:true encoding:NSUTF8StringEncoding error:nil];
}

// Dismiss the keyboard
-(BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    if ([text isEqualToString:@"\n"]) {
        [textView resignFirstResponder];
    }
    return true;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
