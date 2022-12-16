from flask import Flask, jsonify, request
# from flask_ngrok import run_with_ngrok

import torch
import io
import torchvision.transforms as transforms
from PIL import Image
import io

# import custom data / utils
from data import *
from utils import *
from models.model import *
from train import *


app = Flask(__name__)
# run_with_ngrok(app)

pt_path = './models/checkpoint/resnet50.pt'

def load_model(pt_path):
  # ResNet50
  model = resnet50(pretrained=True)
  model.load_state_dict(torch.load(pt_path))
  DEVICE = torch.device("cuda" if torch.cuda.is_available() else "cpu")
  model= model.to(DEVICE)
  # only for inference
  model.eval()
  
  return model

def transform_img(img_byte):
   
  quickdraw_transforms = transforms.Compose([
    transforms.Resize(32),
    transforms.CenterCrop(28),
    transforms.Grayscale(),
    transforms.ToTensor(),
    transforms.Normalize((0.1702,), (0.3224)),
  ])
  
  img = Image.open(io.BytesIO(img_byte))
  
  # batch_size = 1
  transform_img = quickdraw_transforms(img).unsqueeze(0)
  
  return transform_img

# tensor index to label
def idx_to_str_label(pred):
  labels = get_labels()
  idx = int(pred.item())
  label_name = labels[idx]
  return idx, label_name

def get_prediction(img_byte):
  transform_img = transform_img(img_byte=img_byte)
  
  model = load_model()
  preds = model(transform_img)
  # top prediction
  pred = preds.argmax(dim=1, keepdim = True)
  
  idx, pred_label_name = idx_to_str_label(pred)
  
  return idx, pred_label_name

@app.route('/', methods=['GET'])
def root():
    return jsonify({'msg' : 'Try POSTing to the /predict endpoint with an image byte file'})

# 

@app.route('/predict', methods=['POST'])
def predict():
    if request.method == 'POST':
        img_byte = request.files['img']
        if img_byte is not None:
            label_id, label_name = get_prediction(img_byte=img_byte)
            
    return jsonify({'label_id' : label_id, 'label_name': label_name})


if __name__ == '__main__':
    app.run(host='0.0.0.0', port=5000)