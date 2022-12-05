import torch

def get_accuracy(y_pred, y):
    # get the index of the max log-probability
    pred = y_pred.argmax(dim=1, keepdim = True)
    correct = pred.eq(y.view_as(pred)).float().sum().item()
    acc = correct / y.shape[0]
    return acc


def train(model, train_loader, criterion, optimizer, DEVICE):  
    train_loss = 0
    train_acc = 0
    train_iteration = len(train_loader)
    
    model.train()

    for (X, y) in train_loader:
        X = X.type(torch.float32).to(DEVICE)
        y = y.type(torch.LongTensor).to(DEVICE)
        
        # preciction error
        y_pred = model(X)
        loss = criterion(y_pred, y)
        
        # backpropagation
        optimizer.zero_grad()
        loss.backward()
        optimizer.step()
        
        acc = get_accuracy(y_pred, y)
        train_loss += loss.item()
        train_acc += acc
    
    train_loss /= train_iteration
    train_acc /= train_iteration

        
    return train_loss, train_acc
  

def evaluate(model, val_loader, criterion, DEVICE):  
    val_loss = 0
    val_acc = 0
    val_iteration = len(val_loader)
    
    model.eval()
    
    with torch.no_grad():
        for (X, y) in val_loader:
            X = X.type(torch.float32).to(DEVICE)
            y = y.type(torch.LongTensor).to(DEVICE)
            y_pred = model(X)
            
            # caculate loss & acc
            loss = criterion(y_pred, y)
            acc = get_accuracy(y_pred, y)
            
             # sum up batch loss
            val_loss += loss.item()
            val_acc += acc
            
    val_loss /= val_iteration
    val_acc /= val_iteration

    return val_loss, val_acc

def epoch_time(start_time, end_time):
    elapsed_time = end_time - start_time
    elapsed_mins = int(elapsed_time / 60)
    elapsed_secs = int(elapsed_time - (elapsed_mins * 60))
    return elapsed_mins, elapsed_secs