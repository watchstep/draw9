import os
import torch
import  numpy as np
import random
import matplotlib.pyplot as plt

# Setting seed
def set_seed(seed):
    # os.environ['PYTHONASHSEED'] = 0 무작위화 비활성화
    os.environ['PYTHONHASHSEED'] = str(seed)
    torch.manual_seed(seed)
    torch.cuda.manual_seed(seed)
    torch.cuda.manual_seed_all(seed)
    np.random.seed(seed)
    random.seed(seed)

# Save plt as png
def save_figure(figure_name, figure_base_path = './assets/', figure_extension='.png', resolution=300):
    # make directory
    try:
        if not os.path.exists(figure_base_path):
            os.makedirs(figure_base_path)
    except:
      print('already exists')
    
    figure_path = figure_base_path + figure_name + figure_extension
    print('save figure: ', figure_name)
    
    plt.savefig(figure_path, bbox_inches='tight', format=figure_extension[1:], dpi=resolution)
    
    
# Get cpu or gpu device for training
def check_device():
    if torch.cuda.is_available():
        DEVICE = torch.device('cuda')
    else:
        DEVICE = torch.deivce('cpu')
    
    print('Using Pytorch version : ',  torch.__version__, 'DEVICE : ', DEVICE)
    
    return DEVICE

# show image & save image
def imshow(img, label):
  img = img / 2 + 0.5  # unnormalize
  npimg = img.numpy()
  plt.figure(figsize=(5, 5))
  plt.imshow(np.transpose(npimg, (1, 2, 0)))
  plt.axis('off')
  plt.show()