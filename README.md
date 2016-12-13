Fourier Transform in Dart
=========================

Motivation
----------

I'd like to perform a Fourier Transform on some data, but I cannot afford a
MATLAB. So I decided to roll my own.

Here it is.

Spec
----

Since my data is discrete, the FT implemented here is discrete Fourier
transform, and in particular - Fast Fourier Transform. This takes a descrete
list of data points, assuming equal time spacing between the values, and returns
the frequency domain representation in a selected range.

https://en.wikipedia.org/wiki/Fourier_transform
https://en.wikipedia.org/wiki/Discrete_Fourier_transform
https://en.wikipedia.org/wiki/Fast_Fourier_transform
https://en.wikipedia.org/wiki/Cooley%E2%80%93Tukey_FFT_algorithm
