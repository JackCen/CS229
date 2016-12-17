---
name: BVLC GoogleNet Model
caffemodel: Inception21k.caffemodel
caffemodel_url: http://www.dlsi.ua.es/~pertusa/deep/Inception21k.caffemodel
license: unrestricted
sha1: 405fc5acd08a3bb12de8ee5e23a96bec22f08204
caffe_commit: bc614d1bd91896e3faceaf40b23b72dab47d44f5
---

# Inception-BN full for Caffe

Inception-BN ImageNet (21K classes) model for Caffe.

The model can be downloaded from: http://www.dlsi.ua.es/~pertusa/deep/Inception21k.caffemodel

It was directly converted from the MXNet ImageNet21k model at: https://github.com/dmlc/mxnet-model-gallery/blob/master/imagenet-21k-inception.md

MXNet Batch Normalization is translated into Caffe using a BatchNorm layer
with the learned mean and variance (and scale=1), followed by a Scale layer that applies the learned gamma and beta.

The file deploy.prototxt was generated with the code at symbol_inception-bn-full.cc.

The code for model conversion (MXNet -> Caffe) can be found here: https://github.com/pertusa/MXNetToCaffeConverter

Licensed under CC0
