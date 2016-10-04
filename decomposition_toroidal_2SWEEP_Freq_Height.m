% Multipole Decomposotion with toroidal moment separation.
% ver 2.2.05

clc
clear all;

norm_length = 1e9;   % value to multiply for m->nm converting  % ��������, �� ������� ���������, ����� ��������� ����� � ���������
% norm_length = 1e6; % value to multiply for m->um converting  % ��������, �� ������� ���������, ����� ��������� ����� � ����������

n_max = 10;	% set MANUALLY, number of parametric sweep steps, maximum graphic slider parameter  % �������� �������, ����� ����� � parametric sweep, ������������ �������� ��������
n_min = 4;	% minimum graphic slider parameter and first considered parameter                   % ����������� �������� ��������; ������ � ������� ������� ��������� �� ����� ����������
n = 4;     	% The original (first after fig creating) graphic slider parameter                  % �������������� �������� ��������

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Constants
mu0 = 1.25663706 * 10^(-6);	% Vacuum permeability (magnetic constant)     % ��������� ���������� 
eps0 = 8.85 * 10^(-12);		% Vacuum permittivity (electric constant)     % ������������� ����������
c = 2.998e+8; 				% speed of light                              % �������� �����
% Z = 120*pi; 				% for phase diagrams, still legacy parameter  % ��� ������� ��������

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Independent Variables

E0x = 1 ; 
E0 = 1;

rad = 100e-9;	% base edge of pyramid/parallelepiped/etc or radius of sphere/cilinder/cone/etc, in METERS, MANUALLY, for Normalization! MUST BE CHECKED.  % ������� ��������� �������� � ������, ��������� ���� ��������� �� ����������� �������!
geomCS = rad^2; % effective geometrical cross-section for normalization, if it has square shape.  % ����������� ���������� ������� ��������� ��� ���������� �� ����
%geomCS = pi*rad^2; % effective geometrical cross-section for normalization, if it has circle shape. 
% geomCS = 1e-18; % for usual normalization by nm  % ���������� �� �� �������!
% geomCS = 1e-12; % for usual normalization by um  % ���������� �� ��� �������!
  
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

epsilon_tbl = dlmread ('Px.txt', '' ,5,0); 	% read data from file, delete 5 top strings (header in COMSOL export files) % �������� ������ �� �����, �������� 5 ������� �����

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Frequency array creating
FRE = unique( epsilon_tbl(:, 1)');	% read all elements from 1 column and leave only unique elements % ��������� �� 1 ������� ��� �������� � ��������� ������ ����������                                                      
length_fre = size(FRE,2);			% number of frequency steps, frequency vector length  % ����� ����� �� �������, ����� ������� ������                                                                 
fre = ones(n_max, length_fre);
for i = 1:1:n_max
	fre(i,:) = fre(i,:) .* FRE; 	% create the matrix, containing n_max column-vectors fre, from one column-vector fre (for matrix dimension match)   % ������ �� ������-������ fre �������, ��������� �� n_max ������-������� fre
end
clear FRE;
lambda = c./fre;  					% wavelength as speed of light divided by frequency % ����� ����� - �������� ����� ������ �� �������

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
epsd = 1;		 	% Permittivity of environment outside of the particle % �������������� ������������� ����� ������� �������
k0 = - 2*pi*fre/c; 	% k-vector % �������� ������
				  	% minus here, cause at COMSOL there is minus at the imaginary exponent e^(-i k*x), describing incident radiation
				  	% ����� ������ ��� � COMSOL ����� ����� � ������ ���������� e^(-i k*x), ����������� �������� ���������

kd = k0 .* sqrt(epsd); % k-vector in the environment outside of the particle % �������� ������ � �����
vd2 = c ./ sqrt(epsd); % speed of light in the environment outside of the particle, vd for scattering cross-section without dependence of minus in k0 
					   % �������� ����� � �����, vd ��� ������� ��������� ��� ����������� �� ������ � k0

% vd = c ./ sqrt(epsd);
vd = 2.*pi.*fre./( k0 .* sqrt(epsd) ); 	% speed of light in the environment too, with this vd extinction calculations works well.
										% ���� �������� ����� � �����. � ���� vd ������ ��������� ����������.

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Height, Meters
% ������ � ������
H = ones(n_max, length_fre);
for i = 1:1:length_fre
H(:,i) = H(:,i) .* epsilon_tbl(1+(i-1)*n_max : 1 : i*n_max, 2);
end

Px = ones(n_max, length_fre);
for i = 1:1:length_fre
Px(:,i) = Px(:,i) .* epsilon_tbl(1+(i-1)*n_max : 1 : i*n_max, 4);
end

epsilon_tbl = dlmread ('Py.txt', '' ,5,0);
Py = ones(n_max, length_fre);
for i = 1:1:length_fre
Py(:,i) = Py(:,i) .* epsilon_tbl(1+(i-1)*n_max : 1 : i*n_max, 4);	% read each n_max-th element from 4-th column, beginning from n-th element % ��������� �� 4 ������� ������� � n-���� �������� ������ n_max �������
end

epsilon_tbl = dlmread ('Pz.txt', '' ,5,0);
Pz  = ones(n_max, length_fre);
for i = 1:1:length_fre
Pz(:,i) = Pz(:,i) .* epsilon_tbl(1+(i-1)*n_max : 1 : i*n_max, 4);
end

epsilon_tbl = dlmread ('Tx.txt', '' ,5,0);
Tx  = ones(n_max, length_fre);
for i = 1:1:length_fre
Tx(:,i) = Tx(:,i) .* epsilon_tbl(1+(i-1)*n_max : 1 : i*n_max, 4);
end

epsilon_tbl = dlmread ('Ty.txt', '' ,5,0);
Ty  = ones(n_max, length_fre);
for i = 1:1:length_fre
Ty(:,i) = Ty(:,i) .* epsilon_tbl(1+(i-1)*n_max : 1 : i*n_max, 4);
end

epsilon_tbl=dlmread ('Tz.txt', '' ,5,0);
Tz  = ones(n_max, length_fre);
for i = 1:1:length_fre
Tz(:,i) = Tz(:,i) .* epsilon_tbl(1+(i-1)*n_max : 1 : i*n_max, 4);
end

% Scattering cross-section normalization by Poynting vector of incident radiation
% ���������� ������� ��������� �� ������ ��������� ��������� ���������
epsilon_tbl=dlmread ('scat.txt', '' ,5,0);
scat  = ones(n_max, length_fre);
for i = 1:1:length_fre
scat(:,i) = scat(:,i) .* epsilon_tbl(1+(i-1)*n_max : 1 : i*n_max, 4) ./ 1.3E-3;	% Scattering cross-section, Watts % ������� ��������� � ������
end                   % cross-section normalization by Poynting vector of incident radiation  % ���������� ������� �� ������ ��������� ��������� ���������

epsilon_tbl=dlmread ('mx.txt', '' ,5,0);
mx  = ones(n_max, length_fre);
for i = 1:1:length_fre
mx(:,i) = mx(:,i) .* epsilon_tbl(1+(i-1)*n_max : 1 : i*n_max, 4);
end

epsilon_tbl=dlmread ('my.txt', '' ,5,0);
my  = ones(n_max, length_fre);
for i = 1:1:length_fre
my(:,i) = my(:,i) .* epsilon_tbl(1+(i-1)*n_max : 1 : i*n_max, 4);
end

epsilon_tbl=dlmread ('mz.txt', '' ,5,0);
mz  = ones(n_max, length_fre);
for i = 1:1:length_fre
mz(:,i) = mz(:,i) .* epsilon_tbl(1+(i-1)*n_max : 1 : i*n_max, 4);
end

epsilon_tbl=dlmread ('Mxx.txt', '' ,5,0);
Mxx  = ones(n_max, length_fre);
for i = 1:1:length_fre
Mxx(:,i) = Mxx(:,i) .* epsilon_tbl(1+(i-1)*n_max : 1 : i*n_max, 4);
end

epsilon_tbl=dlmread ('Mxy.txt', '' ,5,0);
Mxy  = ones(n_max, length_fre);
for i = 1:1:length_fre
Mxy(:,i) = Mxy(:,i) .* epsilon_tbl(1+(i-1)*n_max : 1 : i*n_max, 4);
end

epsilon_tbl=dlmread ('Mxz.txt', '' ,5,0);
Mxz  = ones(n_max, length_fre);
for i = 1:1:length_fre
Mxz(:,i) = Mxz(:,i) .* epsilon_tbl(1+(i-1)*n_max : 1 : i*n_max, 4);
end

epsilon_tbl=dlmread ('Myx.txt', '' ,5,0);
Myx  = ones(n_max, length_fre);
for i = 1:1:length_fre
Myx(:,i) = Myx(:,i) .* epsilon_tbl(1+(i-1)*n_max : 1 : i*n_max, 4);
end

epsilon_tbl=dlmread ('Myy.txt', '' ,5,0);
Myy  = ones(n_max, length_fre);
for i = 1:1:length_fre
Myy(:,i) = Myy(:,i) .* epsilon_tbl(1+(i-1)*n_max : 1 : i*n_max, 4);
end

epsilon_tbl=dlmread ('Myz.txt', '' ,5,0);
Myz  = ones(n_max, length_fre);
for i = 1:1:length_fre
Myz(:,i) = Myz(:,i) .* epsilon_tbl(1+(i-1)*n_max : 1 : i*n_max, 4);
end

epsilon_tbl=dlmread ('Mzx.txt', '' ,5,0);
Mzx  = ones(n_max, length_fre);
for i = 1:1:length_fre
Mzx(:,i) = Mzx(:,i) .* epsilon_tbl(1+(i-1)*n_max : 1 : i*n_max, 4);
end

epsilon_tbl = dlmread ('Mzy.txt', '' ,5,0);
Mzy  = ones(n_max, length_fre);
for i = 1:1:length_fre
Mzy(:,i) = Mzy(:,i) .* epsilon_tbl(1+(i-1)*n_max : 1 : i*n_max, 4);
end

epsilon_tbl = dlmread ('Mzz.txt', '' ,5,0);
Mzz  = ones(n_max, length_fre);
for i = 1:1:length_fre
Mzz(:,i) = Mzz(:,i) .* epsilon_tbl(1+(i-1)*n_max : 1 : i*n_max, 4);
end

epsilon_tbl = dlmread ('Qxx.txt', '' ,5,0);
Qxx  = ones(n_max, length_fre);
for i = 1:1:length_fre
Qxx(:,i) = Qxx(:,i) .* epsilon_tbl(1+(i-1)*n_max : 1 : i*n_max, 4);
end

epsilon_tbl = dlmread ('Qyy.txt', '' ,5,0);
Qyy  = ones(n_max, length_fre);
for i = 1:1:length_fre
Qyy(:,i) = Qyy(:,i) .* epsilon_tbl(1+(i-1)*n_max : 1 : i*n_max, 4);
end

epsilon_tbl = dlmread ('Qzz.txt', '' ,5,0);
Qzz  = ones(n_max, length_fre);
for i = 1:1:length_fre
Qzz(:,i) = Qzz(:,i) .* epsilon_tbl(1+(i-1)*n_max : 1 : i*n_max, 4);
end

epsilon_tbl = dlmread ('Qxy.txt', '' ,5,0);
Qxy  = ones(n_max, length_fre);
for i = 1:1:length_fre
Qxy(:,i) = Qxy(:,i) .* epsilon_tbl(1+(i-1)*n_max : 1 : i*n_max, 4);
end

epsilon_tbl = dlmread ('Qxz.txt', '' ,5,0);
Qxz  = ones(n_max, length_fre);
for i = 1:1:length_fre
Qxz(:,i) = Qxz(:,i) .* epsilon_tbl(1+(i-1)*n_max : 1 : i*n_max, 4);
end

epsilon_tbl = dlmread ('Qyx.txt', '' ,5,0);
Qyx  = ones(n_max, length_fre);
for i = 1:1:length_fre
Qyx(:,i) = Qyx(:,i) .* epsilon_tbl(1+(i-1)*n_max : 1 : i*n_max, 4);
end

epsilon_tbl = dlmread ('Qyz.txt', '' ,5,0);
Qyz  = ones(n_max, length_fre);
for i = 1:1:length_fre
Qyz(:,i) = Qyz(:,i) .* epsilon_tbl(1+(i-1)*n_max : 1 : i*n_max, 4);
end

epsilon_tbl = dlmread ('Qzx.txt', '' ,5,0);
Qzx  = ones(n_max, length_fre);
for i = 1:1:length_fre
Qzx(:,i) = Qzx(:,i) .* epsilon_tbl(1+(i-1)*n_max : 1 : i*n_max, 4);
end

epsilon_tbl = dlmread ('Qzy.txt', '' ,5,0);
Qzy  = ones(n_max, length_fre);
for i = 1:1:length_fre
Qzy(:,i) = Qzy(:,i) .* epsilon_tbl(1+(i-1)*n_max : 1 : i*n_max, 4);
end

epsilon_tbl = dlmread ('Oxxx.txt', '' ,5,0);
Oxxx  = ones(n_max, length_fre);
for i = 1:1:length_fre
Oxxx(:,i) = Oxxx(:,i) .* epsilon_tbl(1+(i-1)*n_max : 1 : i*n_max, 4);
end

epsilon_tbl = dlmread ('Oxxy.txt', '' ,5,0);
Oxxy  = ones(n_max, length_fre);
for i = 1:1:length_fre
Oxxy(:,i) = Oxxy(:,i) .* epsilon_tbl(1+(i-1)*n_max : 1 : i*n_max, 4);
end

epsilon_tbl = dlmread ('Oxxz.txt', '' ,5,0);
Oxxz  = ones(n_max, length_fre);
for i = 1:1:length_fre
Oxxz(:,i) = Oxxz(:,i) .* epsilon_tbl(1+(i-1)*n_max : 1 : i*n_max, 4);
end

epsilon_tbl = dlmread ('Oyyx.txt', '' ,5,0);
Oyyx  = ones(n_max, length_fre);
for i = 1:1:length_fre
Oyyx(:,i) = Oyyx(:,i) .* epsilon_tbl(1+(i-1)*n_max : 1 : i*n_max, 4);
end

epsilon_tbl = dlmread ('Oyyy.txt', '' ,5,0);
Oyyy  = ones(n_max, length_fre);
for i = 1:1:length_fre
Oyyy(:,i) = Oyyy(:,i) .* epsilon_tbl(1+(i-1)*n_max : 1 : i*n_max, 4);
end

epsilon_tbl = dlmread ('Oyyz.txt', '' ,5,0);
Oyyz  = ones(n_max, length_fre);
for i = 1:1:length_fre
Oyyz(:,i) = Oyyz(:,i) .* epsilon_tbl(1+(i-1)*n_max : 1 : i*n_max, 4);
end

epsilon_tbl = dlmread ('Ozzx.txt', '' ,5,0);
Ozzx  = ones(n_max, length_fre);
for i = 1:1:length_fre
Ozzx(:,i) = Ozzx(:,i) .* epsilon_tbl(1+(i-1)*n_max : 1 : i*n_max, 4);
end

epsilon_tbl = dlmread ('Ozzy.txt', '' ,5,0);
Ozzy  = ones(n_max, length_fre);
for i = 1:1:length_fre
Ozzy(:,i) = Ozzy(:,i) .* epsilon_tbl(1+(i-1)*n_max : 1 : i*n_max, 4);
end

epsilon_tbl = dlmread ('Ozzz.txt', '' ,5,0);
Ozzz  = ones(n_max, length_fre);
for i = 1:1:length_fre
Ozzz(:,i) = Ozzz(:,i) .* epsilon_tbl(1+(i-1)*n_max : 1 : i*n_max, 4);
end

epsilon_tbl = dlmread ('Oxyz.txt', '' ,5,0);
Oxyz  = ones(n_max, length_fre);
for i = 1:1:length_fre
Oxyz(:,i) = Oxyz(:,i) .* epsilon_tbl(1+(i-1)*n_max : 1 : i*n_max, 4);
end

epsilon_tbl = dlmread ('Lambdax.txt', '' ,5,0);
Lambdax  = ones(n_max, length_fre);
for i = 1:1:length_fre
Lambdax(:,i) = Lambdax(:,i) .* epsilon_tbl(1+(i-1)*n_max : 1 : i*n_max, 4);
end

epsilon_tbl = dlmread ('Lambday.txt', '' ,5,0);
Lambday  = ones(n_max, length_fre);
for i = 1:1:length_fre
Lambday(:,i) = Lambday(:,i) .* epsilon_tbl(1+(i-1)*n_max : 1 : i*n_max, 4);
end

epsilon_tbl = dlmread ('Lambdaz.txt', '' ,5,0);
Lambdaz  = ones(n_max, length_fre);
for i = 1:1:length_fre
Lambdaz(:,i) = Lambdaz(:,i) .* epsilon_tbl(1+(i-1)*n_max : 1 : i*n_max, 4);
end

epsilon_tbl = dlmread ('absCS.txt', '' ,5,0); % Absorption, Watts % ���������� � ������
absCS  = ones(n_max, length_fre);
for i = 1:1:length_fre
absCS(:,i) = absCS(:,i) .* epsilon_tbl(1+(i-1)*n_max : 1 : i*n_max, 4);
end
absCS = absCS ./ 1.3E-3;    % absorption normalization by Poynting vector of incident radiation   % ���������� ���������� �� ������ ��������� ��������� ���������
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Extinction components for the wave, directed along Z and polarized along X
% ���������� ���������� ��� ����� ������������ �� Z � �������������� �� X
ExtPx 	= ( kd ./ (eps0.*epsd .* abs(E0x).^2) ) .* imag( conj(E0x) .* Px);
ExtTx 	= ( kd ./ (eps0.*epsd .* abs(E0x).^2) ) .* imag( conj(E0x) .* ((1i.*kd./vd).*1.*Tx) );
ExtQxz	= ( kd ./ (eps0.*epsd .* abs(E0x).^2) ) .* imag( conj(E0x) .* (-(1i.*kd./6).*Qxz) );
Extmy 	= ( kd ./ (eps0.*epsd .* abs(E0x).^2) ) .* imag( conj(E0x) .* (my./vd) );
ExtMyz 	= ( kd ./ (eps0.*epsd .* abs(E0x).^2) ) .* imag( conj(E0x) .* ((1i.*kd./(2.*vd)).*Myz) );
ExtOxzz = ( kd ./ (eps0.*epsd .* abs(E0x).^2) ) .* imag( conj(E0x) .* (-(kd.*kd./6) .* (Ozzx-Lambdax)) );


TxK = ((1i.*kd./vd) .* Tx);
TyK = ((1i.*kd./vd) .* Ty);
TzK = ((1i.*kd./vd) .* Tz);

% Extinction as sum of multipole components
% ���������� ��� ����� ������������� �����������x
ExtCS = ExtPx+ExtTx+ExtQxz+Extmy+ExtMyz+ExtOxzz;

% Components of Total Electric Dipole Moment (TED)
% ���������� ������� �������������� ���������� �������
Dx = Px - (1i.*k0.*epsd./c).*Tx;
Dy = Py - (1i.*k0.*epsd./c).*Ty;
Dz = Pz - (1i.*k0.*epsd./c).*Tz;

% I incident - Poynting vector of incident wave, power flux density
% ������ ��������� �������� �����, ��������� ������ ��������
Iinc = ((eps0*epsd/mu0)^0.5*E0/2);

% Contributions of separate miltipoles at the power scattering, normalized by Poynting vector
% ������ ��������� ����������� � ��������� �������� ������������� �� ������ ���������
ScatD = (k0.^4./(12.*pi.*eps0.^2.*vd2.*mu0)) .* (abs(Dx).^2 + abs(Dy).^2 + abs(Dz).^2) ./ Iinc; 	% Electric Dipole % ������

Scatm = ((k0.^4.*epsd./(12.*pi*eps0.*vd2)) .* (abs(mx).^2+abs(my).^2+abs(mz).^2)) ./ Iinc;  % Magnetic Dipole % ��������� ������

ScatQ=((k0.^6.*epsd./(1440.*pi.*eps0.^2.*vd2.*mu0))... 									% Electric Quadrupole % ������������� ����������
    .*(abs(Qxx).^2+abs(Qxy).^2+abs(Qxz).^2+abs(Qyx).^2+abs(Qyy).^2+abs(Qyz).^2+...
    abs(Qzx).^2+abs(Qzy).^2+abs(Qzz).^2)) ./ Iinc; 											

ScatM = ((k0.^6.*epsd.^2./(160.*pi*eps0.^1.*vd2)) ...									% Magnetic quadrupole % ��������� ����������
    .*(abs(Mxx).^2+abs(Mxy).^2+abs(Mxz).^2+abs(Myx).^2+abs(Myy).^2+abs(Myz).^2+...
    abs(Mzx).^2+abs(Mzy).^2+abs(Mzz).^2) ) ./ Iinc; 										

% octupole parts from COMSOL % �������� �� �������� �� �������
FullOxyz = Oxyz;
FullOxxy = Oxxy-Lambday;
FullOxxz = Oxxz-Lambdaz;
FullOyyx = Oyyx-Lambdax;
FullOyyz = Oyyz-Lambdaz;
FullOzzx = Ozzx-Lambdax;
FullOzzy = Ozzy-Lambday;
FullOxxx = Oxxx-3.*Lambdax;
FullOyyy = Oyyy-3.*Lambday;
FullOzzz = Ozzz-3.*Lambdaz;

ScatO = ((k0.^8.*epsd.^2./(3780.*pi.*eps0.^2.*vd2.*mu0)).*(6.*abs(FullOxyz).^2+3.*abs(FullOxxy).^2+...	% Electric Octupole % ������������� ��������
    3.*abs(FullOxxz).^2+3.*abs(FullOyyx).^2+3.*abs(FullOyyz).^2+3.*abs(FullOzzx).^2+...
    3.*abs(FullOzzy).^2+abs(FullOxxx).^2+abs(FullOyyy).^2+abs(FullOzzz).^2)) ./ Iinc ;  		
                
% Scattering cross-section as sum of multipole components
% ������� ��������� ��� ����� ������������� �����������
ScatCS = (ScatD + Scatm + ScatQ + ScatM + ScatO) ; 


lambda_nm = lambda .* norm_length; 	% converting wavelenght from m to nm % ��������� ����� ����� �� ������ � ���������
H = H .* norm_length; 				% converting height to nm % ��������� ������ � ���������
FontSize = 15; 			% font size at the titles % ������ ������ � ��������
LineWidth = 2.3; 		% Line Width at the graphics % ������� ����� �� ��������

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

fig1 = figure (1);

pl1 = @(n) plot (lambda_nm(n,:), abs(Px(n,:))./geomCS, ...
	 			lambda_nm(n,:), abs(TxK(n,:) + Px(n,:))./geomCS, ...
	 			lambda_nm(n,:), abs(TxK(n,:))./geomCS, ...
	 			'LineWidth', LineWidth);
xlab1 = @() xlabel ('Wavelength, nm','FontSize', FontSize);
ylab1 = @() ylabel ('dipole, a.u.','FontSize', FontSize);
leg1 =  @() legend( 'ED','ED+TD','TD');
tit1 = 	@(n) title(strcat('Height h = ', num2str(H(n,1)), ' nm'),'FontSize', FontSize);
slider_toroidal( fig1, pl1, xlab1, ylab1, leg1, tit1, n, n_min, n_max, H);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Multipoles contributions to Extincntion
% ������ ����������� � ����������
fig2 = figure(2);

pl2 = @(n) plot (lambda_nm(n,:), ExtPx(n,:)./geomCS, ...
				lambda_nm(n,:), ExtTx(n,:)./geomCS, ...
				lambda_nm(n,:), ExtQxz(n,:)./geomCS, ...
				lambda_nm(n,:), Extmy(n,:)./geomCS, ...
				lambda_nm(n,:), ExtMyz(n,:)./geomCS, ...
				lambda_nm(n,:), ExtOxzz(n,:)./geomCS, ...
                lambda_nm(n,:), ExtCS(n,:)./geomCS, ...
	 			'LineWidth', LineWidth);
tit2 = @(n) title(strcat('Multipoles contributions to Extincntion, h = ', num2str(H(n,1)), ' nm' ),'FontSize', FontSize);
xlab2 = @() xlabel ('Wavelength ,nm','FontSize', FontSize);
ylab2 = @() ylabel ('Multipoles contributions, um^2','FontSize', FontSize); % um - ����������
leg2 = @() legend('Px','Tx','Qxz','my','Myz','Oxzz','Total Ext-on Cross Sect. as Sum');
slider_toroidal( fig2, pl2, xlab2, ylab2, leg2, tit2, n, n_min, n_max, H );

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% All Cross-sections % ��� ������� 
fig3 = figure(3);

pl3 = @(n) plot (lambda_nm(n,:), abs(ExtCS(n,:))./geomCS, ...
				lambda_nm(n,:), scat(n,:)./geomCS, ...
				lambda_nm(n,:), absCS(n,:)./geomCS, ...
				lambda_nm(n,:), (scat(n,:)+absCS(n,:))./geomCS, ...
				lambda_nm(n,:), ScatCS(n,:)./geomCS, ...
	 			'LineWidth', LineWidth);
tit3 = @(n) title(strcat('Cross section, h = ', num2str(H(n,1)), ' nm' ),'FontSize', FontSize);
xlab3 = @() xlabel ('Wavelength, nm','FontSize', FontSize);
ylab3 = @() ylabel ('Cross section, mkm^2','FontSize', FontSize);
leg3 = @() legend('Extincntion cross section','Scattering cross section from COMSOL','Absorption cross section from COMSOL', 'Extinction cross section from COMSOL (Abs+Scat)', 'Scatterning cross section' );
slider_toroidal( fig3, pl3, xlab3, ylab3, leg3, tit3, n, n_min, n_max, H );

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Scattering cross-sections only % ������ ���������
fig4 = figure (4);

pl4 = @(n) plot (lambda_nm(n,:), ScatCS(n,:)./geomCS, ...
				lambda_nm(n,:), scat(n,:)./geomCS, ...
	 			'LineWidth', LineWidth);
tit4 = @(n) title(strcat('Cross section, h = ', num2str(H(n,1)),' nm' ),'FontSize', FontSize);
xlab4 = @() xlabel ('Wavelength, nm','FontSize', FontSize);
ylab4 = @() ylabel ('Cross section, um^2','FontSize', FontSize);
leg4 = @() legend('Scattering cross section', 'Scattering cross section from COMSOL');
slider_toroidal( fig4, pl4, xlab4, ylab4, leg4, tit4, n, n_min, n_max, H );

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

fig5 = figure (5);

pl5 = @(n) plot (lambda_nm(n,:), ScatD(n,:)./geomCS, ...
				lambda_nm(n,:), Scatm(n,:)./geomCS, ...
				lambda_nm(n,:), ScatQ(n,:)./geomCS, ...
				lambda_nm(n,:), ScatM(n,:)./geomCS, ...
				lambda_nm(n,:), ScatO(n,:)./geomCS, ...
				lambda_nm(n,:), ScatCS(n,:)./geomCS, ...
	 			'LineWidth', LineWidth);
tit5 = @(n) title(strcat('Multipoles Contributions to Scattering, h = ', num2str(H(n,1)), ' nm' ),'FontSize', FontSize);
xlab5 = @() xlabel ('Wavelenght, nm','FontSize', FontSize);
ylab5 = @() ylabel ('Multipoles Contributions, um^2','FontSize', FontSize);
leg5 = @() legend('scat D ', 'scat m', 'scat Q', 'scat M', 'scat O', 'Sum Scat');
slider_toroidal( fig5, pl5, xlab5, ylab5, leg5, tit5, n, n_min, n_max, H );

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% At the MaxValue 
% 1st line - maximum value                                        % 1 ������ - ������������ �������� ��������
% 2nd line - frequency, corresponding to this value               % 2 ������ - ������� ��������������� ����� ��������
% 3rd line - wavelenght, corresponding to this value              % 3 ������ - ����� ����� ��������������� ����� ��������
% 4th line - value of parameter, corresponding to maximum value   % 4 ������ - �������� ��������� �������� ������������� ������������ ��������

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


Maxscat = MaxValue(scat./geomCS, fre, H, n_max); 

fig6 = figure(6);
set(fig6, 'Units', 'normalized', 'OuterPosition', [0.01 0.045 0.98 0.95]);

% Dependence: max of Scattering Cross-Section (Comsol) according to Height

subplot(1,2,1)
plot(Maxscat(4,n_min:end), Maxscat(1,n_min:end), 'r--o');
title('Max Scat. Cross-section (COMSOL) according to h');
xlabel ('Height, nm');
ylabel ('Max Scat C-S, a.u.');

% Dependence: Wavelenght, corresponding to max Scattering Cross-Section (Comsol) according to Height
subplot(1,2,2)
plot(Maxscat(4,n_min:end), Maxscat(3,n_min:end).*norm_length, 'r--o'); 
title('the Wavelength corresponding to the Max Scat. Cross-section (COMSOL)');
xlabel ('Height, nm');
ylabel ('Res Wavelength, nm');
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


MaxAbs = MaxValue(absCS./geomCS, fre, H, n_max); 

fig7 = figure(7);
set(fig7, 'Units', 'normalized', 'OuterPosition', [0.01 0.045 0.98 0.95]);

% Dependence: max of Absorption Cross-Section (Comsol) according to Height

subplot(1,2,1)
plot(MaxAbs(4,n_min:end), MaxAbs(1,n_min:end), 'r--o');
title('Max Abs. Cross-section (COMSOL) according to h');
xlabel ('Height, nm');
ylabel ('Max Abs C-S, a.u.');

% Dependence: Wavelenght, corresponding to max Absorption Cross-Section (Comsol) according to Height
subplot(1,2,2)
plot(MaxAbs(4,n_min:end), MaxAbs(3,n_min:end).*norm_length, 'r--o'); 
title('the Wavelength corresponding to the Max Abs. Cross-section (COMSOL)');
xlabel ('Height, nm');
ylabel ('Res Wavelength, nm');
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

MaxScatD = MaxValue(ScatD./geomCS, fre, H, n_max); 

fig8 = figure(8);
set(fig8, 'Units', 'normalized', 'OuterPosition', [0.01 0.045 0.98 0.95]);

% Dependence: max of Scattering component by Total Electric Dipole according to Height

subplot(1,2,1)
plot(MaxScatD(4,n_min:end), MaxScatD(1,n_min:end), 'r--o');
title('Max TED according to h');
xlabel ('Height, nm');
ylabel ('Max scat TED, a.u.');

% Dependence: Wavelenght, corresponding to max of scattering component by Total Electric Dipole according to Height
subplot(1,2,2)
plot(MaxScatD(4,n_min:end), MaxScatD(3,n_min:end).*norm_length, 'r--o'); 
title('the Wavelength corresponding to the Max TED');
xlabel ('Height, nm');
ylabel ('Res Wavelength, nm');
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
Maxm = MaxValue(Scatm./geomCS, fre, H, n_max); 

fig9 = figure(9);
set(fig9, 'Units', 'normalized', 'OuterPosition', [0.01 0.045 0.98 0.95]);

% Dependence: max of Scattering component by Magnetic Dipole according to Height
subplot(1,2,1)
plot(Maxm(4,n_min:end), Maxm(1,n_min:end), 'r--o');
title('Max magnetic dipole according to h');
xlabel ('Height, nm');
ylabel ('Max scat m, a.u.');

% Dependence: Wavelenght, corresponding to max Magnetic Dipole according to Height
subplot(1,2,2)
plot(Maxm(4,n_min:end), Maxm(3,n_min:end).*norm_length, 'r--o'); 
title('the Wavelength coresponding to the Max m');
xlabel ('Height, nm');
ylabel ('Wavelength, nm');

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
MaxQ = MaxValue(ScatQ./geomCS, fre, H, n_max); 

fig10 = figure(10);
set(fig10, 'Units', 'normalized', 'OuterPosition', [0.01 0.045 0.98 0.95]);

% Dependence: max of Scattering component by Electric Quadrupole according to Height
subplot(1,2,1)
plot(MaxQ(4,n_min:end), MaxQ(1,n_min:end), 'r--o');
title('Max Electric Quadrupole according to h');
xlabel ('Height, nm');
ylabel ('Max scat Q, a.u.');

% Dependence: Wavelenght, corresponding to max Electric Quadrupole according to Height
subplot(1,2,2)
plot(MaxQ(4,n_min:end), MaxQ(3,n_min:end).*norm_length, 'r--o'); 
title('the Wavelength coresponding to the Max Q');
xlabel ('Height, nm');
ylabel ('Wavelength, nm');

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
MaxM = MaxValue(ScatM./geomCS, fre, H, n_max); 

fig11 = figure(11);
set(fig11, 'Units', 'normalized', 'OuterPosition', [0.01 0.045 0.98 0.95]);

% Dependence: max of Scattering component by Magnetic Quadrupole according to Height
subplot(1,2,1)
plot(MaxM(4,n_min:end), MaxM(1,n_min:end), 'r--o');
title('Max magnetic Quadrupole according to h');
xlabel ('Height, nm');
ylabel ('Max scat M, a.u.');

% Dependence: Wavelenght, corresponding to max Magnetic Quadrupole to Height
subplot(1,2,2)
plot(MaxM(4,n_min:end), MaxM(3,n_min:end).*norm_length, 'r--o'); 
title('the Wavelength coresponding to the Max M');
xlabel ('Height, nm');
ylabel ('Wavelength, nm');

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

MaxRel = MaxValue(abs(TxK+Px)./abs(Px), fre, H, n_max); 

fig12 = figure(12);
set(fig12, 'Units', 'normalized', 'OuterPosition', [0.01 0.045 0.98 0.95]);

% Dependence: max of (TD+ED)/ED according to Height
% ����������� ��������� ��������� ����� ������������� � �������������� ���������� �������� �� ������
subplot(1,2,1)
plot(MaxRel(4,n_min:end), MaxRel(1,n_min:end), 'r--o');
title('Max (TD+ED)/ED according to h');
xlabel ('Height, nm');
ylabel ('Max scat M, a.u.');

% Dependence: Wavelenght, corresponding to max (TD+ED)/ED to Height
% ����������� ����� �����, ��������������� ��������� ��������� ����� ������������� � �������������� ���������� ��������, �� ������
subplot(1,2,2)
plot(MaxRel(4,n_min:end), MaxRel(3,n_min:end).*norm_length, 'r--o'); 
title('the Wavelength coresponding to the Max (TD+ED)/ED');
xlabel ('Height, nm');
ylabel ('Wavelength, nm');

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%