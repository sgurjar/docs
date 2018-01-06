Following are main parts-
* `Layers`, model (or network) is made of.
* `Input Data` and corresponding `Targets` (Labels).
* `Loss Function`, feedback signal used for learning. Are we getting closer to learning.
* `Optimizer`, determines how learning proceeds. Adjust the weights to get close to targets.

![](https://github.com/sgurjar/docs/blob/master/__assets/neural-network-1.png)

## Layers

Different layers are appropriate for different tensor formats and different types of data processing.

* `Dense`: Simple vector data, stored in 2D tensors of shape (samples,
  features), is often processed by densely connected layers, also called
  fully connected or dense layers (the Dense class in Keras)

* `LSTM`: Sequence data, stored in 3D tensors of shape (samples,
  timesteps, features), is typically processed by recurrent layers such
  as an LSTM layer.

* `Conv2D`: Image data, stored in 4D tensors, is usually processed by
  2D convolution layers (Conv2D).

```python
from keras import layers
      # dens layer with 32 output units
layer = layers.Dense(32, input_shape=(784,))
```
- input 2D tensors, first dim 784
- that is, 784 features or 784 columns
- number of rows or axis 0 is unspecified
- will take any number of rows, the batch dim.
- input of 784 columsn will be transformed to 32 columns output.
- Thus this layer can be connected t another layet that takes 32 columns vector as input.

```python
from keras import models
from keras import layers
model = models.Sequential()
model.add(layers.Dense(32, input_shape=(784,)))
model.add(layers.Dense(32))

# The second layer didn’t receive an input shape argument—instead, 
# it automatically inferred its input shape as being the output 
# shape of the layer that came before.
```
* A deep-learning model is a directed, acyclic graph of layers.
* Network topologies
  - Two-branch networks
  - Multihead networks
  - Inception blocks
* Learning is defined as "searching for useful representations of 
  some input data, within a predefined space of possibilities, using 
  guidance from a feedback signal."
* "Space of possibilities" is our "hypothesis space".
* Network topology defines _hypothesis space_.

## Loss Function (Objective Function)
The quantity that will be minimized during training. 
It represents a __measure of success__ for the task at hand.

## Optimizer
Determines how the network will be updated based on the loss function.
It implements a specific variant of stochastic gradient descent (SGD).

## Structure of Keras Model

### input data

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

### network

```python
network = models.Sequential()
network.add(layers.Dense(512, activation='relu', input_shape=(28 * 28,)))
network.add(layers.Dense(10, activation='softmax'))
```

This network consists of a chain of two `Dense` layers, that each layer 
applies a few simple tensor operations to the input data, and that these
operations involve weight tensors. __Weight tensors__, which are attributes 
of the layers, are where the __knowledge__ of the network persists.

### network-compilation

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

### training loop

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
