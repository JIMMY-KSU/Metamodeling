function [VDM1]  = determine_VDM_fast(umR1, umS1)

VDM1 = zeros(10, length(umR1));

VDM1(1,:) = (umR1(:)*0+1)';
VDM1(2,:) = (umR1(:))';
VDM1(3,:) = (umS1(:))';
VDM1(4,:) = (umR1(:).^2)';
VDM1(5,:) = (umR1(:).*umS1(:))';
VDM1(6,:) = (umS1(:).^2)';
VDM1(7,:) = (VDM1(4,:).*umR1(:)');
VDM1(8,:) = (VDM1(5,:).*umR1(:)');
VDM1(9,:) = (VDM1(6,:).*umR1(:)');
VDM1(10,:)= (VDM1(6,:).*umS1(:)');

