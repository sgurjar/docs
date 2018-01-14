```python
from keras import layers
from keras import models
```

    Using TensorFlow backend.

```python
model = models.Sequential()
```

### Instantiating a small convnet

```python
model.add(layers.Conv2D(32, (3, 3), activation='relu', input_shape=(28, 28, 1)))
model.add(layers.MaxPooling2D((2, 2)))
model.add(layers.Conv2D(64, (3, 3), activation='relu'))
model.add(layers.MaxPooling2D((2, 2)))
model.add(layers.Conv2D(64, (3, 3), activation='relu'))
```

```python
model.summary()
```

    _________________________________________________________________
    Layer (type)                 Output Shape              Param #
    =================================================================
    conv2d_1 (Conv2D)            (None, 26, 26, 32)        320
    _________________________________________________________________
    max_pooling2d_1 (MaxPooling2 (None, 13, 13, 32)        0
    _________________________________________________________________
    conv2d_2 (Conv2D)            (None, 11, 11, 64)        18496
    _________________________________________________________________
    max_pooling2d_2 (MaxPooling2 (None, 5, 5, 64)          0
    _________________________________________________________________
    conv2d_3 (Conv2D)            (None, 3, 3, 64)          36928
    =================================================================
    Total params: 55,744
    Trainable params: 55,744
    Non-trainable params: 0
    _________________________________________________________________

### Adding a classifier on top of the convnet

```python
model.add(layers.Flatten())
model.add(layers.Dense(64, activation='relu'))
model.add(layers.Dense(10, activation='softmax'))
```

```python
model.summary()
```

    _________________________________________________________________
    Layer (type)                 Output Shape              Param #
    =================================================================
    conv2d_1 (Conv2D)            (None, 26, 26, 32)        320
    _________________________________________________________________
    max_pooling2d_1 (MaxPooling2 (None, 13, 13, 32)        0
    _________________________________________________________________
    conv2d_2 (Conv2D)            (None, 11, 11, 64)        18496
    _________________________________________________________________
    max_pooling2d_2 (MaxPooling2 (None, 5, 5, 64)          0
    _________________________________________________________________
    conv2d_3 (Conv2D)            (None, 3, 3, 64)          36928
    _________________________________________________________________
    flatten_1 (Flatten)          (None, 576)               0
    _________________________________________________________________
    dense_1 (Dense)              (None, 64)                36928
    _________________________________________________________________
    dense_2 (Dense)              (None, 10)                650
    =================================================================
    Total params: 93,322
    Trainable params: 93,322
    Non-trainable params: 0
    _________________________________________________________________

### Training the convnet on MNIST images

```python
from keras.datasets import mnist
from keras.utils import to_categorical
```

```python
(train_images, train_labels), (test_images, test_labels) = mnist.load_data()
```

```python
train_images = train_images.reshape((60000, 28, 28, 1))
train_images = train_images.astype('float32') / 255
test_images = test_images.reshape((10000, 28, 28, 1))
test_images = test_images.astype('float32') / 255
train_labels = to_categorical(train_labels)
test_labels = to_categorical(test_labels)
model.compile(optimizer='rmsprop',
loss='categorical_crossentropy',
metrics=['accuracy'])
model.fit(train_images, train_labels, epochs=5, batch_size=64)
```

    Epoch 1/5
    60000/60000 [==============================] - 52s 865us/step - loss: 0.1775 - acc: 0.9446
    Epoch 2/5
    60000/60000 [==============================] - 51s 843us/step - loss: 0.0470 - acc: 0.9853
    Epoch 3/5
    60000/60000 [==============================] - 51s 844us/step - loss: 0.0329 - acc: 0.9897
    Epoch 4/5
    60000/60000 [==============================] - 51s 843us/step - loss: 0.0252 - acc: 0.9925
    Epoch 5/5
    60000/60000 [==============================] - 51s 843us/step - loss: 0.0194 - acc: 0.9937

    <keras.callbacks.History at 0x7fab20d2f190>

```python
test_loss, test_acc = model.evaluate(test_images, test_labels)
```

    10000/10000 [==============================] - 3s 279us/step

```python
test_acc
```

    0.99039999999999995

```python
test_loss
```

    0.028119460725577666

