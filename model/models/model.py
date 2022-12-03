import math
import torch, torchvision
import torch.nn as nn
from torch import optim
import torch.nn.functional as F
from torchvision import models

# https://github.com/fastai/fastai/blob/master/fastai/vision/learner.py
# https://pytorch.org/tutorials/beginner/finetuning_torchvision_models_tutorial.html
# Access first layer of a model
def _get_first_layer(m):
    c,p,n = m,None,None  # child, parent, name
    for n in next(m.named_parameters())[0].split('.')[:-1]:
        p,c=c,getattr(c,n)
    return c,p,n


# Load pretrained weights based on number of input channels
def _load_pretrained_weights(new_layer, previous_layer):
    n_in = getattr(new_layer, 'in_channels')
    if n_in==1:
        # we take the sum
        new_layer.weight.data = previous_layer.weight.data.sum(dim=1, keepdim=True)
    elif n_in==2:
        # we take first 2 channels + 50%
        new_layer.weight.data = previous_layer.weight.data[:,:2] * 1.5
    else:
        # keep 3 channels weights and set others to null
        new_layer.weight.data[:,:3] = previous_layer.weight.data
        new_layer.weight.data[:,3:].zero_()

# Change first layer based on number of input channels
def _update_first_layer(model, n_in, pretrained):
    if n_in == 3: return
    first_layer, parent, name = _get_first_layer(model)
    assert isinstance(first_layer, nn.Conv2d), f'Change of input channels only supported with Conv2d, found {first_layer.__class__.__name__}'
    assert getattr(first_layer, 'in_channels') == 3, f'Unexpected number of input channels, found {getattr(first_layer, "in_channels")} while expecting 3'
    params = {attr:getattr(first_layer, attr) for attr in 'out_channels kernel_size stride padding dilation groups padding_mode'.split()}
    params['bias'] = getattr(first_layer, 'bias') is not None
    params['in_channels'] = n_in
    new_layer = nn.Conv2d(**params)
    if pretrained:
        _load_pretrained_weights(new_layer, first_layer)
    setattr(parent, name, new_layer)
    
    
def resnet18(num_classes=30):
    model = models.resnet18(pretrained=True)
     # transfer learning on grayscale image
    _update_first_layer(model=model, n_in=1, pretrained=True)
    fc_features = model.fc.in_features
    model.fc = nn.Linear(fc_features, num_classes, bias=True)
    
    nn.init.kaiming_normal_(model.fc.weight)
    stdv = 1. / math.sqrt(model.fc.weight.size(1))
    model.fc.bias.data.uniform_(-stdv, stdv)
    
    return model
    
    
def resnet34(num_classes=30):
    model = models.resnet34(pretrained=False)
    
    conv1_out_channels = model.conv1.out_channels
    model.conv1 = nn.Conv2d(1, conv1_out_channels, kernel_size=3,
                            stride=1, padding=1, bias=False)
  
    fc_features = model.fc.in_features
    model.fc = nn.Linear(fc_features, num_classes)
    
    nn.init.kaiming_normal_(model.fc.weight)
    stdv = 1. / math.sqrt(model.fc.weight.size(1))
    model.fc.bias.data.uniform_(-stdv, stdv)

    return model
  
  
def resnet50(num_classes=30):
    model = models.resnet50(pretrained=False)
    
    conv1_out_channels = model.conv1.out_channels
    model.conv1 = nn.Conv2d(1, conv1_out_channels, kernel_size=3,
                            stride=1, padding=1, bias=True)
  
    fc_features = model.fc.in_features
    model.fc = nn.Linear(in_features=fc_features, out_features=num_classes, bias=True)
    nn.init.kaiming_normal_(model.fc.weight)
    stdv = 1. / math.sqrt(model.fc.weight.size(1))
    model.fc.bias.data.uniform_(-stdv, stdv)

    return model


def mobilenetV2(num_classes=30):
    model = models.mobilenet_v2(pretrained=False)
    
    _update_first_layer(model=model, n_in=1, pretrained=False)
    
    model.classifier[1] = nn.Linear(in_features=model.classifier[1].in_features, out_features=num_classes)
    
    return model


class DrawCNN(nn.Module):
    def __init__(self, input_size = 28, num_classes = 30):
        super(DrawCNN, self).__init__()
        self.num_classes = num_classes
        self.conv1 = nn.Sequential(nn.Conv2d(1, 32, 3, bias=False), nn.ReLU(inplace=True), nn.MaxPool2d(2))
        self.conv2 = nn.Sequential(nn.Conv2d(32, 64, 3, bias=False), nn.ReLU(inplace=True), nn.MaxPool2d(2))
        self.conv3 = nn.Sequential(nn.Conv2d(64, 256, 3))
        self.fc1 = nn.Sequential(nn.Linear(dimension, 512), nn.Dropout())
        self.fc2 = nn.Sequential(nn.Linear(512, 128), nn.Dropout())
        self.fc3 = nn.Sequential(nn.Linear(128, num_classes))

    def forward(self, input):
        output = self.conv1(input)
        output = self.conv2(output)
        output = output.view(output.size(0), -1)
        output = self.fc1(output)
        output = self.fc2(output)
        output = self.fc3(output)
        return output
