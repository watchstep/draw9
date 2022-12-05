import os
import urllib.request
from . import get_labels

def load_dataset(dataset_path='./dataset/'):
  # make directory
  try:
    if not os.path.exists(dataset_path):
      os.makedirs(dataset_path)
  except:
      None
      
  # get data from web
  labels = get_labels()
  base_url = 'https://storage.googleapis.com/quickdraw_dataset/full/numpy_bitmap/'
  for label in labels:
    label_url = label.replace('_', '%20')
    npy_url = base_url + label_url + '.npy'
    print(npy_url)
    urllib.request.urlretrieve(npy_url, dataset_path + label + '.npy')

  print('Done!')


  