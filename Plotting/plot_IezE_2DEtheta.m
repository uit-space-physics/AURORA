function txth = plot_IezE_2DEtheta(h_atm,E,dE,Ie_ZE,BeamW,mu_lims,iZ,cxin)
%  plot_IezE_2DEtheta - energy-pitch-angle electron flux plot
%  plot_IezE_2DEtheta plots the pitch-angle energy electron
%  fluxes varying with energy - pitch-angle at a selected altitude
%  The electron-fluxes are plotted in log-scale with polarPcolor. 
%
% Calling:
%  output = plot_IezE_2DEtheta(h_atm,E,dE,Ie_ZE,BeamW,mu_lims,iZ,movieOut)
% Input:
%  h_atm      - altitudes (km), double array [n_z x 1]
%  E          - energies (eV), double array [1 x n_E]
%  Ie_ztE     - electron number-flux, double array [n_z*n_beams,n_t,n_E]
%  dE         - energy bin sizes (eV), double array [1 x n_E]
%  BeamSA     - solid angle sizes of the beams, [n_beams x 1]
%  mu_lims    - beam-boundaries, (cos(theta_b)), [n_beams x 1] or
%               [1 x n_beams]
%  iZ         - index in altitude, scalar integer, iZ should be in
%               [1,...,n_z]


%   Copyright � 20200114 Bj�rn Gustavsson, <bjorn.gustavsson@uit.no>
%   This is free software, licensed under GNU GPL version 2 or later


if nargin < 10 || isempty(cxin)
  cx2use = ([-5 0]+12.25);
else
  cx2use = cxin;
end
nZ = numel(h_atm);
%% Extracting electron flux at 4 altitudes

for iz = 1,
  Ie_alts{iz} = Ie_ZE(iZ(iz):nZ:end,:);
end

%% Graphics settings:
ftsz = 14;
xtxtpos = [0,1.3]; % Altitude-label above change 1.3 to -1.3 for below
suptpos = [1.1,1.4];
cblpos = [-0.7,-0.3];

%% Animationing
caxis(cx2use)
for ip = 1
  IePAD{ip}(:,:) = squeeze(Ie_alts{ip}([1:end,end],:))./...
      (dE(1:size(Ie_ZE,2))'*BeamW([1:end,end]))';
  polarPcolor(log10(E(1:size(Ie_ZE,2))),...
              acos(mu_lims)*180/pi,...
              log10(max(1e7,squeeze(Ie_alts{ip}([1:end,end],:))./...
                        (dE(1:size(Ie_ZE,2))'*BeamW([1:end,end]))')),...
              'Ncircles',3,...
              'Nspokes',7,...
              'Rvals',[1 2 3],...
              'Rticklabel',{'10^1','10^2','10^3'});
  alt_str = sprintf('z: %2.1f (km)',h_atm(iZ(ip)));
  % text(xtxtpos(1),xtxtpos(2),'height: 610 km','fontsize',ftsz)
  txth(1) = text(xtxtpos(1),xtxtpos(2),alt_str,'fontsize',ftsz);
  txth(2) = text(cblpos(1),cblpos(2),'(e^{-1}/m^2/s/ster/eV)','rotation',90);
  caxis(cx2use)
end
