
clc
clear all

global zero_app
global tol_nr 
global max_iter

load('globalvar.mat');

UI
s = input('Enter the coefficient vector for the polynomial function to solve-\n', 's');
p = str2num(s);
if isnan(p)
    p = eval(s);
end

r = PolySolve(p);
if (length(r) == 0)
    disp('No real roots found!!')
    return
end

disp('Real roots:');
disp(r);
disp('Their corresponding multiplicities:');
disp(PolyMult(p, r));
