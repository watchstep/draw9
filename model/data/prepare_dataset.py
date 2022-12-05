import numpy as np
import glob as gb
from sklearn.model_selection import train_test_split
import torch
from torchvision import transforms
from torch.utils.data import Dataset, random_split, TensorDataset
import os


class QuickDrawDataset(Dataset):
    def __init__(self, subset, transform=None):
        self.subset = subset
        self.transform = transform
        
    def __getitem__(self, index):
        x, y = self.subset[index]
        if self.transform:
            x = self.transform(x)
        return x, y
        
    def __len__(self):
        return len(self.subset)
    
# https://stackoverflow.com/questions/44429199/how-to-load-a-list-of-numpy-arrays-to-pytorch-dataset-loader
# https://velog.io/@dust_potato/Data-Augmentation-%EC%96%B4%EB%96%A4-transform%EC%9D%84-%EC%A4%98%EC%95%BC-%EC%9E%98%ED%96%88%EB%8B%A4%EA%B3%A0-%EC%86%8C%EB%AC%B8%EC%9D%B4-%EB%82%A0%EA%B9%8C

def prepare_dataset(npy_files_path='./dataset/*.npy',test_ratio=0.2, max_items_per_class=10000):
    npy_files = gb.glob(npy_files_path)

    #initialize variables 
    X = np.empty([0, 784]) # 28*28 =784
    y = np.empty([0])
    classes = []

    #load a subset of the data to memory 
    for idx, npy_file in enumerate(npy_files):
        data = np.load(npy_file)
        data = data[0:max_items_per_class, :]
        labels = np.full(data.shape[0], idx)

        X = np.concatenate((X, data), axis=0)
        y = np.append(y, labels)
    
        label, extension = os.path.splitext(os.path.basename(npy_file))
        classes.append(label)

    data = None
    labels = None
    
    # transform to torch tensor
    X_tensor = torch.Tensor(X)
    X_tensor = X_tensor.reshape(X_tensor.shape[0], 1, 28, 28)
    # normalizatoin
    X_tensor /= 255.0
    y_tensor = torch.Tensor(y)
    
    X_train, X_test, y_train, y_test = train_test_split(X_tensor, y_tensor, test_size=test_ratio, random_state=1, stratify=y_tensor)
    X_test, X_val, y_test, y_val = train_test_split(X_test, y_test, test_size=0.5, random_state=1, stratify=y_test)
    
    # create dataset
    dataset = TensorDataset(X_tensor, y_tensor)
    train_dataset = TensorDataset(X_train, y_train)
    val_dataset = TensorDataset(X_val, y_val)
    test_dataset = TensorDataset(X_test, y_test)
    
    # caculate mean & std
    means = torch.zeros(1)
    stds = torch.zeros(1)
    
    for img, label in train_dataset:
        means += torch.mean(img, dim = (1,2))
        stds += torch.std(img, dim = (1,2))
        
    means /= len(train_dataset)
    stds /= len(train_dataset)
    
    print(f'Means: {means}')
    print(f'STDs: {stds}')
    
    # transform
    transforms_train = transforms.Compose([
        transforms.Normalize((0.1702,), (0.3224)),
        transforms.GaussianBlur(kernel_size=(7, 13))
    ])
    
    transforms_test = transforms.Compose([
        transforms.Normalize((0.1702,), (0.3224))
    ])
    
    train_dataset = QuickDrawDataset(subset=train_dataset, transform=transforms_train)
    val_dataset = QuickDrawDataset(subset=val_dataset, transform=transforms_test)
    test_dataset = QuickDrawDataset(subset=test_dataset, transform=transforms_test)
    
    
    return dataset, train_dataset, val_dataset, test_dataset, classes
