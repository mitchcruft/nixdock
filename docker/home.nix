{ config, pkgs, ... }:

(
let
  stateVersion = "24.05";
  username = "m";
  homeDirectory = "/home/m";
in import ./home-manager { inherit pkgs username stateVersion homeDirectory; }
).home-manager.users.m { inherit pkgs; }
