import {
  LightningElement,
  api
} from 'lwc';
import {
  NavigationMixin
} from 'lightning/navigation';

export default class Parallaxcmp extends NavigationMixin(LightningElement) {

  @api backgroundImage;
  @api mainTitle;
  @api fontColor;
  @api overlayColor
  @api imageHeight
  @api fontSize;

  get myImage() {
    return "min-height:" + this.imageHeight + "px; background-position: 50% 50%;background-size: cover;background-image: url('../s/sfsites/c/resource/" + this.backgroundImage;
  }

  get myTextColor() {
    console.log('the font color is ', this.fontColor);
    return "font-size:" + this.fontSize + "px; color: " + this.fontColor;
  }

  get myOverlay() {
    return "background-color: " + this.overlayColor;
  }


}