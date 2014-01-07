//
//  AGPhotoBrowserOverlayView.m
//  AGPhotoBrowser
//
//  Created by Hellrider on 7/28/13.
//  Copyright (c) 2013 Andrea Giavatto. All rights reserved.
//

#import "AGPhotoBrowserOverlayView.h"

#import <QuartzCore/QuartzCore.h>
#import "AGPhotoBrowserOverlayGradientView.h"

@interface AGPhotoBrowserOverlayView () {
	BOOL _animated;
}

@property (nonatomic, strong) UIView *sharingView;
@property (nonatomic, strong) AGPhotoBrowserOverlayGradientView *gradientView;
@property (nonatomic, assign) BOOL descriptionExpanded;
@property (nonatomic, strong) UITapGestureRecognizer *tapGesture;

@property (nonatomic, strong, readwrite) UILabel *titleLabel;
@property (nonatomic, strong, readwrite) UILabel *descriptionLabel;
@property (nonatomic, strong) UIView *separatorView;
@property (nonatomic, strong) UIButton *seeMoreButton;
@property (nonatomic, strong, readwrite) UIButton *actionButton;

@property (nonatomic, assign, readwrite, getter = isVisible) BOOL visible;

@end


@implementation AGPhotoBrowserOverlayView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
		[self setupView];
    }
    return self;
}
/*
- (void)layoutSubviews
{
	[super layoutSubviews];
		
	self.titleLabel.frame = CGRectMake(20, 35, CGRectGetWidth(self.frame) - 40, 20);
	self.separatorView.frame = CGRectMake(20, CGRectGetMinY(self.titleLabel.frame) + CGRectGetHeight(self.titleLabel.frame), CGRectGetWidth(self.titleLabel.frame), 1);
    
	if (self.descriptionExpanded) {
		CGSize descriptionSize;
		if (floor(NSFoundationVersionNumber) <= NSFoundationVersionNumber_iOS_6_1) {
			descriptionSize = [_description sizeWithFont:self.descriptionLabel.font  constrainedToSize:CGSizeMake(CGRectGetWidth([UIScreen mainScreen].bounds) - 40, MAXFLOAT)];
		} else {
			NSDictionary *textAttributes = @{NSFontAttributeName : self.descriptionLabel.font};
			CGRect descriptionBoundingRect = [_description boundingRectWithSize:CGSizeMake(CGRectGetWidth([UIScreen mainScreen].bounds) - 40, MAXFLOAT)
																					  options:NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading attributes:textAttributes
																					  context:nil];
			descriptionSize = CGSizeMake(ceil(CGRectGetWidth(descriptionBoundingRect)), ceil(CGRectGetHeight(descriptionBoundingRect)));
		}
		self.descriptionLabel.frame = CGRectMake(20, CGRectGetMinY(self.separatorView.frame) + CGRectGetHeight(self.separatorView.frame) + 10, 280, descriptionSize.height);
	} else {
		self.descriptionLabel.frame = CGRectMake(20, CGRectGetMinY(self.separatorView.frame) + CGRectGetHeight(self.separatorView.frame) + 10, 220, 20);
		self.seeMoreButton.frame = CGRectMake(240, CGRectGetMinY(self.separatorView.frame) + CGRectGetHeight(self.separatorView.frame) + 10, 65, 20);
	}
    
	if ([self.descriptionLabel.text length]) {
		CGSize descriptionSize;
		if (floor(NSFoundationVersionNumber) <= NSFoundationVersionNumber_iOS_6_1) {
			descriptionSize = [self.descriptionLabel.text sizeWithFont:self.descriptionLabel.font  constrainedToSize:CGSizeMake(self.descriptionLabel.frame.size.width, MAXFLOAT)];
		} else {
			NSDictionary *textAttributes = @{NSFontAttributeName : self.descriptionLabel.font};
			CGRect descriptionBoundingRect = [self.descriptionLabel.text boundingRectWithSize:CGSizeMake(self.descriptionLabel.frame.size.width, MAXFLOAT)
																				   options:NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading attributes:textAttributes
																				   context:nil];
			descriptionSize = CGSizeMake(ceil(CGRectGetWidth(descriptionBoundingRect)), ceil(CGRectGetHeight(descriptionBoundingRect)));
		}
        if (descriptionSize.height > self.descriptionLabel.frame.size.height) {
            self.seeMoreButton.hidden = NO;
        } else {
            self.seeMoreButton.hidden = YES;
        }
        self.descriptionLabel.hidden = NO;
    } else {
        self.descriptionLabel.hidden = YES;
        self.seeMoreButton.hidden = YES;
    }
	
    if ([_title length]) {
		self.titleLabel.hidden = NO;
		self.separatorView.hidden = NO;
	} else {
		self.titleLabel.hidden = YES;
		self.separatorView.hidden = YES;
	}
	
	self.actionButton.frame = CGRectMake(CGRectGetWidth(self.sharingView.frame) - 55 - 10, CGRectGetHeight(self.sharingView.frame) - 32 - 5, 55, 32);
}*/

- (void)setupView
{
	self.alpha = 0;
	self.userInteractionEnabled = YES;
    
	[self.sharingView addSubview:self.titleLabel];
	[self.sharingView addSubview:self.separatorView];
	[self.sharingView addSubview:self.descriptionLabel];
	[self.sharingView addSubview:self.seeMoreButton];
	[self.sharingView addSubview:self.actionButton];
	
	[self addSubview:self.sharingView];
    [self setNeedsUpdateConstraints];
}

- (void)updateConstraints
{
    [self removeConstraints:self.constraints];
    
    NSDictionary *constrainedViews = NSDictionaryOfVariableBindings(_sharingView, _gradientView, _titleLabel, _separatorView, _descriptionLabel, _seeMoreButton, _actionButton);
    
    // -- Vertical constraints
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[_sharingView]|"
                                                                 options:0
                                                                 metrics:@{}
                                                                   views:constrainedViews]];
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[_gradientView]|"
                                                                 options:0
                                                                 metrics:@{}
                                                                   views:constrainedViews]];
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-(==35)-[_titleLabel(==20)][_separatorView(==1)][_descriptionLabel(>=20)]-(==10)-|"
																 options:0
																 metrics:@{}
																   views:constrainedViews]];
	[self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-(>=0)-[_seeMoreButton(==20)]-(==12)-|"
																 options:0
																 metrics:@{}
																   views:constrainedViews]];
	[self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-(>=0)-[_actionButton(==32)]-(==5)-|"
																 options:0
																 metrics:@{}
																   views:constrainedViews]];
    
    // -- Horizontal constraints
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[_sharingView]|"
                                                                 options:0
                                                                 metrics:@{}
                                                                   views:constrainedViews]];
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[_gradientView]|"
                                                                 options:0
                                                                 metrics:@{}
                                                                   views:constrainedViews]];
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-(==20)-[_titleLabel]-(==20)-|"
                                                                 options:0
                                                                 metrics:@{}
                                                                   views:constrainedViews]];
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-(==20)-[_separatorView]-(==20)-|"
                                                                 options:0
                                                                 metrics:@{}
                                                                   views:constrainedViews]];
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-(==20)-[_descriptionLabel][_seeMoreButton(==60)]-(==25)-|"
																 options:0
																 metrics:@{}
																   views:constrainedViews]];
	[self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-(>=0)-[_actionButton(==55)]-(==10)-|"
																 options:0
																 metrics:@{}
																   views:constrainedViews]];
    
    [super updateConstraints];
}


#pragma mark - Public methods

- (void)showOverlayAnimated:(BOOL)animated
{
	_animated = animated;
	self.visible = YES;
}

- (void)hideOverlayAnimated:(BOOL)animated
{
	_animated = animated;
	self.visible = NO;
}
/*
- (void)resetOverlayView
{
	if (floor(CGRectGetHeight(self.frame)) != AGPhotoBrowserOverlayInitialHeight) {
		__block CGRect initialSharingFrame = self.frame;
		initialSharingFrame.origin.y = round(CGRectGetHeight([UIScreen mainScreen].bounds) - AGPhotoBrowserOverlayInitialHeight);
		
		[UIView animateWithDuration:0.15
						 animations:^(){
							 self.frame = initialSharingFrame;
						 } completion:^(BOOL finished){
							 initialSharingFrame.size.height = AGPhotoBrowserOverlayInitialHeight;
							 self.descriptionExpanded = NO;
							 [self setNeedsLayout];
							 [UIView animateWithDuration:AGPhotoBrowserAnimationDuration
											  animations:^(){
												  self.frame = initialSharingFrame;
											  }];
						 }];
	}
}
*/

#pragma mark - Buttons

- (void)p_actionButtonTapped:(UIButton *)sender
{
	if ([_delegate respondsToSelector:@selector(sharingView:didTapOnActionButton:)]) {
		[_delegate sharingView:self didTapOnActionButton:sender];
	}
}

- (void)p_seeMoreButtonTapped:(UIButton *)sender
{
	if ([_delegate respondsToSelector:@selector(sharingView:didTapOnSeeMoreButton:)]) {
		[_delegate sharingView:self didTapOnSeeMoreButton:sender];
		self.descriptionExpanded = YES;
		
		[self.sharingView addGestureRecognizer:self.tapGesture];
	}
}


#pragma mark - Recognizers

- (void)p_tapGestureTapped:(UITapGestureRecognizer *)recognizer
{
	//[self resetOverlayView];
}


#pragma mark - Setters

- (void)setFrame:(CGRect)frame
{
	[super setFrame:frame];

    [self setNeedsUpdateConstraints];
}

- (void)setVisible:(BOOL)visible
{
	_visible = visible;
	
	CGFloat newAlpha = _visible ? 1. : 0.;
	
	NSTimeInterval animationDuration = _animated ? AGPhotoBrowserAnimationDuration : 0;
	
	[UIView animateWithDuration:animationDuration
					 animations:^(){
						 self.alpha = newAlpha;
						 self.actionButton.alpha = newAlpha;
					 }];
}

- (void)setTitle:(NSString *)title
{
	_title = title;
	
    if (_title) {
        self.titleLabel.text = _title;
    }
    
    [self setNeedsUpdateConstraints];
}

- (void)setDescription:(NSString *)description
{
	_description = description;
	
	if ([_description length]) {
		self.descriptionLabel.text = _description;
	} else {
		self.descriptionLabel.text = @"";
	}
    
    [self setNeedsUpdateConstraints];
}


#pragma mark - Getters

- (UIView *)sharingView
{
	if (!_sharingView) {
		_sharingView = [[UIView alloc] initWithFrame:CGRectZero];
        _sharingView.translatesAutoresizingMaskIntoConstraints = NO;

        [_sharingView addSubview:self.gradientView];
	}
	
	return _sharingView;
}

- (AGPhotoBrowserOverlayGradientView *)gradientView
{
    if (!_gradientView) {
        _gradientView = [[AGPhotoBrowserOverlayGradientView alloc] initWithFrame:CGRectZero];
        _gradientView.translatesAutoresizingMaskIntoConstraints = NO;
        _gradientView.layer.colors = [NSArray arrayWithObjects:(id)[[UIColor clearColor] CGColor], (id)[[UIColor blackColor] CGColor], nil];
    }
    
    return _gradientView;
}

- (UILabel *)titleLabel
{
	if (!_titleLabel) {
		_titleLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _titleLabel.translatesAutoresizingMaskIntoConstraints = NO;
		_titleLabel.textColor = [UIColor colorWithWhite:0.9 alpha:0.9];
		_titleLabel.font = [UIFont boldSystemFontOfSize:14];
		_titleLabel.backgroundColor = [UIColor clearColor];
	}
	
	return _titleLabel;
}

- (UIView *)separatorView
{
	if (!_separatorView) {
		_separatorView = [[UIView alloc] initWithFrame:CGRectZero];
        _separatorView.translatesAutoresizingMaskIntoConstraints = NO;
		_separatorView.backgroundColor = [UIColor lightGrayColor];
        //_separatorView.hidden = YES;
	}
	
	return _separatorView;
}

- (UILabel *)descriptionLabel
{
	if (!_descriptionLabel) {
		_descriptionLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _descriptionLabel.translatesAutoresizingMaskIntoConstraints = NO;
		_descriptionLabel.textColor = [UIColor colorWithWhite:0.9 alpha:0.9];
		_descriptionLabel.font = [UIFont systemFontOfSize:13];
		_descriptionLabel.backgroundColor = [UIColor clearColor];
		_descriptionLabel.numberOfLines = 0;
	}
	
	return _descriptionLabel;
}

- (UIButton *)seeMoreButton
{
	if (!_seeMoreButton) {
		_seeMoreButton = [[UIButton alloc] initWithFrame:CGRectZero];
        _seeMoreButton.translatesAutoresizingMaskIntoConstraints = NO;
		[_seeMoreButton setTitle:NSLocalizedString(@"See More", @"Title for See more button") forState:UIControlStateNormal];
		[_seeMoreButton setBackgroundColor:[UIColor clearColor]];
		[_seeMoreButton setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
		_seeMoreButton.titleLabel.font = [UIFont boldSystemFontOfSize:13];
        //_seeMoreButton.hidden = YES;
		
		[_seeMoreButton addTarget:self action:@selector(p_seeMoreButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
	}
	
	return _seeMoreButton;
}

- (UIButton *)actionButton
{
	if (!_actionButton) {
		_actionButton = [[UIButton alloc] initWithFrame:CGRectZero];
        _actionButton.translatesAutoresizingMaskIntoConstraints = NO;
		[_actionButton setTitle:NSLocalizedString(@"● ● ●", @"Title for Action button") forState:UIControlStateNormal];
		[_actionButton setBackgroundColor:[UIColor clearColor]];
		[_actionButton setTitleColor:[UIColor colorWithWhite:0.9 alpha:0.9] forState:UIControlStateNormal];
		[_actionButton setTitleColor:[UIColor colorWithWhite:0.9 alpha:0.9] forState:UIControlStateHighlighted];
		[_actionButton.titleLabel setFont:[UIFont boldSystemFontOfSize:14.0f]];
        
		[_actionButton addTarget:self action:@selector(p_actionButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
	}
	
	return _actionButton;
}

- (UITapGestureRecognizer *)tapGesture
{
	if (!_tapGesture) {
		_tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(p_tapGestureTapped:)];
		_tapGesture.numberOfTouchesRequired = 1;
	}
	
	return _tapGesture;
}

@end
