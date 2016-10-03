% ������������� ������������ � ���������� ������������� �������
% ver 2.1

clc
clear all;

norm_length = 1e9; % ��������, �� ������� ���������, ����� ��������� ����� � ���������
% norm_length = 1e6; % ��������, �� ������� ���������, ����� ��������� ����� � ����������

n_max = 3;	% �������� �������, ����� ����� � parametric sweep, ������������ �������� ��������
n_min = 1;	% ����������� �������� ��������
n = 1;     	% �������������� �������� ��������

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Constants
mu0 = 1.25663706 * 10^(-6);	% ��������� ���������� 
eps0 = 8.85 * 10^(-12);		% ������������� ����������
c = 2.998e+8; 				% �������� �����
% Z = 120*pi; 				% ��� ������� ��������
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

epsilon_tbl = dlmread ('Px.txt', '' ,5,0); 	% �������� ������ �� �����, �������� 5 ������� �����

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% ������ ������ ������
FRE = unique( epsilon_tbl(:, 1)');	% ��������� �� 1 ������� ��� �������� � ��������� ������ ����������
length_fre = size(FRE,2);			% ����� ����� �� �������, ����� ������� ������
fre = ones(n_max, length_fre);
for i = 1:1:n_max
	fre(i,:) = fre(i,:) .* FRE; 	% ������ �� ������-������ fre �������, ��������� �� n_max ������-������� fre
end
clear FRE;
lambda = c./fre;  					% ����� ����� - �������� ����� ������ �� �������

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
epsd = 1;		 	% �������������� ������������� ����� ������� �������
k0 = - 2*pi*fre/c; 	% �������� ������ 
				  	% ����� ������ ��� � COMSOL ����� ����� � ������ ���������� e^(-i k*x), ����������� �������� ���������

kd = k0 .* sqrt(epsd); % �������� ������ � �����
vd2 = c ./ sqrt(epsd); % �������� ����� � �����, vd ��� ������� ��������� ��� ����������� �� ������ � k0
% vd = c ./ sqrt(epsd);
vd = 2.*pi.*fre./( k0 .* sqrt(epsd) ); 	% ���� �������� ����� � �����. � ���� vd ������ ��������� ����������.

E0x = 1 ; 
E0 = 1;
rad = 100e-9;	% ������� ��������� �������� � ������, ��������� ���� ��������� �� ����������� �������!
geomCS = rad^2; % ����������� ���������� ������� ��������� ��� ���������� �� ����
% geomCS = 1e-18; % ���������� �� �� �������!

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Height � ������
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
Py(:,i) = Py(:,i) .* epsilon_tbl(1+(i-1)*n_max : 1 : i*n_max, 4);	% ��������� �� 4 ������� ������� � n-���� �������� ������ n_max �������
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

% ���������� ������� ��������� �� ������ ��������� ��������� ���������
epsilon_tbl=dlmread ('scat.txt', '' ,5,0);
scat  = ones(n_max, length_fre);
for i = 1:1:length_fre
scat(:,i) = scat(:,i) .* epsilon_tbl(1+(i-1)*n_max : 1 : i*n_max, 4) ./ 1.3E-3;	% ������� ��������� � ������
end                   % ���������� ������� ��������� �� ������ ��������� ��������� ���������

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

epsilon_tbl = dlmread ('absCS.txt', '' ,5,0); % ���������� � ������
absCS  = ones(n_max, length_fre);
for i = 1:1:length_fre
absCS(:,i) = absCS(:,i) .* epsilon_tbl(1+(i-1)*n_max : 1 : i*n_max, 4);
end
absCS = absCS ./ 1.3E-3;    % ���������� ���������� �� ������ ��������� ��������� ���������
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

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

% ���������� ��� ����� ������������� ������������
ExtCS = ExtPx+ExtTx+ExtQxz+Extmy+ExtMyz+ExtOxzz;

% ���������� ������� �������������� ���������� �������
Dx = Px - (1i.*k0.*epsd./c).*Tx;
Dy = Py - (1i.*k0.*epsd./c).*Ty;
Dz = Pz - (1i.*k0.*epsd./c).*Tz;

% I incident - ������ ��������� �������� �����, ��������� ������ ��������
Iinc = ((eps0*epsd/mu0)^0.5*E0/2);

% ������ ��������� ����������� � ��������� �������� ������������� �� ������ ���������
ScatD = (k0.^4./(12.*pi.*eps0.^2.*vd2.*mu0)) .* (abs(Dx).^2 + abs(Dy).^2 + abs(Dz).^2) ./ Iinc; 	% ������

Scatm = ((k0.^4.*epsd./(12.*pi*eps0.*vd2)) .* (abs(mx).^2+abs(my).^2+abs(mz).^2)) ./ Iinc;  % ��������� ������

ScatQ=((k0.^6.*epsd./(1440.*pi.*eps0.^2.*vd2.*mu0))... 									% ������������� ����������
    .*(abs(Qxx).^2+abs(Qxy).^2+abs(Qxz).^2+abs(Qyx).^2+abs(Qyy).^2+abs(Qyz).^2+...
    abs(Qzx).^2+abs(Qzy).^2+abs(Qzz).^2)) ./ Iinc; 											

ScatM = ((k0.^6.*epsd.^2./(160.*pi*eps0.^1.*vd2)) ...									% ��������� ����������
    .*(abs(Mxx).^2+abs(Mxy).^2+abs(Mxz).^2+abs(Myx).^2+abs(Myy).^2+abs(Myz).^2+...
    abs(Mzx).^2+abs(Mzy).^2+abs(Mzz).^2) ) ./ Iinc; 										

% �������� �� ��������� �� �������
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

ScatO = ((k0.^8.*epsd.^2./(3780.*pi.*eps0.^2.*vd2.*mu0)).*(6.*abs(FullOxyz).^2+3.*abs(FullOxxy).^2+...	% ������������� ��������
    3.*abs(FullOxxz).^2+3.*abs(FullOyyx).^2+3.*abs(FullOyyz).^2+3.*abs(FullOzzx).^2+...
    3.*abs(FullOzzy).^2+abs(FullOxxx).^2+abs(FullOyyy).^2+abs(FullOzzz).^2)) ./ Iinc ;  		
                
% ������� ��������� ��� ����� ������������� �����������
ScatCS = (ScatD + Scatm + ScatQ + ScatM + ScatO) ; 


lambda_nm = lambda .* norm_length; 	% ��������� ����� ����� �� ������ � ���������
H = H .* norm_length; 				% ��������� ������ � ���������
FontSize = 15; 			% ������ ������ � ��������
LineWidth = 2.3; 		% ������� ����� �� ��������

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

% ��� ������� 
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

% ������ ���������
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

% � MaxValue 
% 1 ������ - ������������ �������� ��������
% 2 ������ - ������� ��������������� ����� ��������
% 3 ������ - ����� ����� ��������������� ����� ��������
% 4 ������ - �������� ��������� �������� ������������� ������������ ��������

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

MaxTxk = MaxValue(abs(TxK), fre, H, n_max); 

fig6 = figure(6);
set(fig6, 'Units', 'normalized', 'OuterPosition', [0.01 0.045 0.98 0.95]);

% ����������� ������������� �������� Txk �� ������
subplot(1,2,1)
plot(MaxTxk(4,:), MaxTxk(1,:), 'o');
title('Max Tx according to h');
xlabel ('Height, nm');
ylabel ('Max Tx, a.u.');

% ����������� ����� ����� ��������������� ������������� �������� Txk �� ������
subplot(1,2,2)
plot(MaxTxk(4,:), MaxTxk(3,:).*norm_length, 'o'); 
title('the Wavelength coresponding to the Max Tx');
xlabel ('Height, nm');
ylabel ('Wavelength, nm');

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

