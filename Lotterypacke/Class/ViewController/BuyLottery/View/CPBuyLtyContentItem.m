//
//  CPBuyLtyContentItem.m
//  lottery
//
//  Created by way on 2018/4/2.
//  Copyright © 2018年 way. All rights reserved.
//

#import "CPBuyLtyContentItem.h"

@interface CPBuyLtyContentItem()
{
    CGFloat _gapBetweenImages;
    CGFloat _gapForBorder;
    CGFloat _gapBetweenImgaeAndText;
}

@property(nonatomic,retain)UILabel *textLabel;
@property(nonatomic,retain)UIButton *singleImgView;
@property(nonatomic,retain)UIView *multiImgView;

@end

@implementation CPBuyLtyContentItem
//NSAttributedString
-(instancetype)init
{
    self = [super init];
    if (self) {
        [self addInitData];
    }
    return self;
}

-(void)awakeFromNib
{
    [super awakeFromNib];
    [self addInitData];
}

-(void)cleanSubviews
{
    if (_textLabel) {
        [_textLabel removeFromSuperview];
        _textLabel = nil;
    }
    if (_singleImgView) {
        [_singleImgView removeFromSuperview];
        _singleImgView = nil;
    }
    if (_multiImgView) {
        [_multiImgView removeFromSuperview];
        _multiImgView = nil;
    }
}

-(void)addInitData
{
    _gapBetweenImages = 2.0f;
    _gapForBorder = 3.0f;
    _gapBetweenImgaeAndText = 8.0f;
}

-(void)setHasSelected:(BOOL)hasSelected
{
    _hasSelected = hasSelected;
    self.backgroundColor = _hasSelected?kCOLOR_R_G_B_A(218, 218, 218, 1):[UIColor clearColor];

}

-(void)addSingleAttributedString:(NSAttributedString *)att
{
    if (_singleImgView) {
        [_singleImgView removeFromSuperview];
        _singleImgView = nil;
    }
    if (_multiImgView) {
        [_multiImgView removeFromSuperview];
        _multiImgView = nil;
    }

    self.textLabel.attributedText = att;
    self.textLabel.frame = CGRectMake(0, 0, self.width, self.height);
}

-(void)addSingleImage:(UIImage *)image
     attributedString:(NSAttributedString *)att
{
    if (_multiImgView) {
        [_multiImgView removeFromSuperview];
        _multiImgView = nil;
    }
    if (_textLabel) {
        [_textLabel removeFromSuperview];
        _textLabel = nil;
    }
    
    [self.singleImgView setBackgroundImage:image forState:UIControlStateNormal];
    [self.singleImgView setAttributedTitle:att forState:UIControlStateNormal];
    self.singleImgView.frame = CGRectMake((self.width-image.size.width)/2.0f, (self.height-image.size.height)/2.0f, image.size.width, image.size.height);
    
}

-(void)addImage:(UIImage *)image
imgAttributedString:(NSAttributedString *)imgAtt
           font:(UIFont *)font
      textColor:(UIColor *)textColor
           text:(NSString *)text
{
    if (_multiImgView) {
        [_multiImgView removeFromSuperview];
        _multiImgView = nil;
    }
    if (self.textLabel.attributedText) {
        self.textLabel.attributedText = nil;
    }
    self.textLabel.text = text;
    self.textLabel.font = font;
    self.textLabel.textColor = textColor;
    
    [self.singleImgView setBackgroundImage:image forState:UIControlStateNormal];
    [self.singleImgView setAttributedTitle:imgAtt forState:UIControlStateNormal];

    CGFloat textWidth = [text suitableFromMaxSize:CGSizeMake(self.width/2.0f, self.height) font:font].width;
    if (textWidth+_gapBetweenImgaeAndText+image.size.width+2*_gapForBorder>self.width) {
        
        CGFloat imgWidth = self.width-(textWidth+_gapBetweenImgaeAndText+2*_gapForBorder);
        CGFloat imgHeight = imgWidth*image.size.height/image.size.width;
        self.singleImgView.frame = CGRectMake(_gapForBorder, (self.height-imgHeight)/2.0f, imgWidth, imgHeight);
        
    }else{
        
        self.singleImgView.frame = CGRectMake((self.width-(textWidth+_gapBetweenImgaeAndText+image.size.width+2*_gapForBorder))/2.0f, (self.height-image.size.height)/2.0f, image.size.width, image.size.height);

    }
    self.textLabel.frame = CGRectMake(self.singleImgView.rightX+_gapBetweenImgaeAndText, 0, textWidth, self.height);

}


-(void)addImages:(NSArray *)images
            font:(UIFont *)font
       textColor:(UIColor *)textColor
            text:(NSString *)text
{
    if (_multiImgView) {
        [_multiImgView removeFromSuperview];
        _multiImgView = nil;
    }
    if (_singleImgView) {
        [_singleImgView removeFromSuperview];
        _singleImgView = nil;
    }

    if (self.textLabel.attributedText) {
        self.textLabel.attributedText = nil;
    }
    
    self.textLabel.text = text;
    self.textLabel.font = font;
    self.textLabel.textColor = textColor;
    
    CGFloat textWidth = [text suitableFromMaxSize:CGSizeMake(self.width/2.0f, self.height) font:font].width;
    CGFloat maxImagesContentViewWidth = self.width - textWidth - _gapForBorder*2 - _gapBetweenImgaeAndText;
    UIImage *imageExp = images[0];
    CGFloat imageWidth = imageExp.size.width;
    CGFloat imageHeight = imageExp.size.height;
    CGFloat factImagesContentViewWidth = images.count*imageWidth+(images.count-1)*_gapBetweenImages;

    if (factImagesContentViewWidth>maxImagesContentViewWidth) {
        factImagesContentViewWidth = maxImagesContentViewWidth;
        CGFloat newImageWidth = (factImagesContentViewWidth- (images.count-1)*_gapBetweenImages)/images.count;
        imageHeight = newImageWidth*imageHeight/imageWidth;
        imageWidth = newImageWidth;
    }
    
    self.multiImgView.frame = CGRectMake((self.width-textWidth-_gapBetweenImgaeAndText-factImagesContentViewWidth)/2.0f, 0, factImagesContentViewWidth, self.height);
    CGFloat imgOrg = 0;
    for (int i = 0; i<images.count; i++) {
        UIImage *img = images[i];
        UIImageView *imgView = [[UIImageView alloc]initWithImage:img];
        imgView.frame = CGRectMake(imgOrg, (self.multiImgView.height-imageHeight)/2.0f, imageWidth, imageHeight);
        [self.multiImgView addSubview:imgView];
        imgOrg = imgView.rightX+_gapBetweenImages;
    }
    
    self.textLabel.frame = CGRectMake(self.multiImgView.rightX+_gapBetweenImgaeAndText, 0, textWidth, self.height);
}

#pragma mark- setter && getter
-(UILabel *)textLabel
{
    
    if (!_textLabel) {
        _textLabel = [[UILabel alloc]init];
        _textLabel.textAlignment = NSTextAlignmentCenter;
        [self addSubview:_textLabel];
    }
    return _textLabel;
}

-(UIButton *)singleImgView
{
    if (!_singleImgView) {
        _singleImgView = [UIButton buttonWithType:UIButtonTypeCustom];
        _singleImgView.userInteractionEnabled = NO;
        [self addSubview:_singleImgView];

    }
    return _singleImgView;
}

-(UIView *)multiImgView
{
    if (!_multiImgView) {
        _multiImgView = [[UIView alloc]init];
        _multiImgView.userInteractionEnabled = NO;
        [self addSubview:_multiImgView];

    }
    return _multiImgView;
}

@end
