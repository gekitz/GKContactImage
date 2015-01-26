GKContactImage
==============

Creates an avatar image like the iOS7 Contacts.app for a given name

Install
==============

```ruby
pod 'GKContactImage'
```

Usage
==============

You simple use the category method with a given name and the size of the image you want to create.

```objc
self.bigImageView.image = [UIImage imageForName:@"Georg Kitz" size:self.bigImageView.frame.size];
```

This would create the following image.

![Sample](https://raw.githubusercontent.com/gekitz/GKContactImage/master/Files/screen.png) 

For a more customized image, use the extra category method with more options.

```objc
self.bigImageView.image = [UIImage imageForName:@"Georg Kitz" size:self.bigImageView.frame.size backgroundColor:[UIColor blackColor] textColor:[UIColor yellowColor] font:[UIFont systemFontOfSize:18.0]];
```


Author
=============

Georg Kitz, [@gekitz](http://twitter.com/gekitz)
