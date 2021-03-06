clear all; close all; clc;

model = elliptic_debug_model([]);
model = elliptic_discrete_model(model);

% Constructs model speci?c high dimensional data for simulations, e.g. the grid.
model_data = gen_model_data(model);

% Computes a solution trajectory
sim_data = detailed_simulation(model, model_data);

% Generates reduced basis space
detailed_data = gen_detailed_data(model, model_data);

% Generates reduced vectors and matrices
reduced_data = gen_reduced_data(model, detailed_data);

% Computes ef?cient a posteriori estimator h(m) estimating the error 
reduced_data = gen_reduced_data(model, detailed_data);