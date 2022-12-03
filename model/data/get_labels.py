# Get image labels
def get_labels(labels_path='./data/30_labels.txt'):
  f = open(labels_path, 'r')
  labels = f.readlines()
  f.close()
  
  labels = [l.replace('\n', '').replace(' ', '_') for l in labels]
  return labels