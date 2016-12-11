---
name: VGG16 CaffeNet Model
caffemodel: vgg16_reference_caffenet.caffemodel
caffemodel_url: http://www.robots.ox.ac.uk/~vgg/software/very_deep/caffe/VGG_ILSVRC_16_layers.caffemodel
license: unrestricted
sha1: 9363e1f6d65f7dba68c4f27a1e62105cdf6c4e24
caffe_commit: 709dc15af4a06bebda027c1eb2b3f3e3375d5077
---

This model is the result of following the Caffe [ImageNet model training instructions](http://caffe.berkeleyvision.org/gathered/examples/imagenet.html).
It is a replication of the model described in the [AlexNet](http://papers.nips.cc/paper/4824-imagenet-classification-with-deep-convolutional-neural-networks) publication with some differences:

- not training with the relighting data-augmentation;
- the order of pooling and normalization layers is switched (in CaffeNet, pooling is done before normalization).

This model is snapshot of iteration 310,000.
The best validation performance during training was iteration 313,000 with validation accuracy 57.412% and loss 1.82328.
This model obtains a top-1 accuracy 57.4% and a top-5 accuracy 80.4% on the validation set, using just the center crop.
(Using the average of 10 crops, (4 + 1 center) * 2 mirror, should obtain a bit higher accuracy still.)

This model was trained by Jeff Donahue @jeffdonahue

## License

This model is released for unrestricted use.
