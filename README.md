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
the frequency domain representation of the series. The series is truncated to
have a length that is the nearest smaller power of two to the length of the one
actually provided. Sorry, I guess you have to limit yourself to power-of-2
lengthed data.

Usage
-----

Simply download, put your data in a file named 'data' (single number per line),
run ft.dart (Dart not included), and your result will pop-up in files names
'fft' and 'amounts'. The first one is the raw output of the FFT, while the
second one is the amount of each frequency present in the original function.

![Example Plot](spectrum.png?raw=true "Example plot")

References
----------

https://en.wikipedia.org/wiki/Fourier_transform
https://en.wikipedia.org/wiki/Discrete_Fourier_transform
https://en.wikipedia.org/wiki/Fast_Fourier_transform
https://en.wikipedia.org/wiki/Cooley%E2%80%93Tukey_FFT_algorithm
