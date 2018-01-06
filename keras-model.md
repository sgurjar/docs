
## input data

```python
from keras.datasets import mnist

(train_images, train_labels), (test_images, test_labels) = mnist.load_data()

train_images = train_images.reshape((60000, 28 * 28))
train_images = train_images.astype('float32') / 255
test_images  = test_images.reshape((10000, 28 * 28))
test_images  = test_images.astype('float32') / 255
```

Here, input images are stored in `Numpy` tensors, which are here
formatted as `float32` tensors of shape `(60000, 784)` (training data) 
and `(10000, 784)` (test data), respectively.

## network

```python
network = models.Sequential()
network.add(layers.Dense(512, activation='relu', input_shape=(28 * 28,)))
network.add(layers.Dense(10, activation='softmax'))
```

This network consists of a chain of two `Dense` layers, that each layer 
applies a few simple tensor operations to the input data, and that these
operations involve weight tensors. __Weight tensors__, which are attributes 
of the layers, are where the __knowledge__ of the network persists.

## network-compilation

```python
network.compile(optimizer='rmsprop', 
                loss='categorical_crossentropy', 
                metrics=['accuracy'])
```

* `categorical_crossentropy` is the loss function that’s used as a feedback signal 
  for learning the weight tensors, and which the training phase will attempt
  to minimize.
* This reduction of the loss happens via minibatch stochastic gradient descent.
  The exact rules governing a specific use of gradient descent are defined by 
  the `rmsprop` optimizer passed as the first argument.

## training loop

```python
network.fit(train_images, train_labels, epochs=5, batch_size=128)
```

* The network will start to iterate on the training data in mini-batches of 
  `128` samples, `5` times over (each iteration over all the training data 
  is called an `epoch`).
  
* At each iteration, the network will compute the gradients of the weights 
  with regard to the `loss` on the batch, and update the weights accordingly.
  
* After these `5` epochs, the network will have performed `2,345` gradient
  updates (`469` per epoch???), and the loss of the network will be 
  sufficiently low that the network will be capable of classifying 
  handwritten digits with high accuracy.
