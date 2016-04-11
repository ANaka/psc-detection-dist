function spatial_posteriors = build_spatial_posteriors(posteriors_grid, neighborhood_size)

spatial_posteriors = struct();


% figure(9991)
% subplot1(size(posteriors_grid,1), size(posteriors_grid,2), 'Gap', [.01 .03], 'XTickL', 'Margin', 'YTickL', 'Margin');
% figure(9992)
% subplot1(size(posteriors_grid,1), size(posteriors_grid,2), 'Gap', [.01 .03], 'XTickL', 'Margin', 'YTickL', 'Margin');
% figure(9993)
% subplot1(size(posteriors_grid,1), size(posteriors_grid,2), 'Gap', [.005 .005], 'XTickL', 'Margin', 'YTickL', 'Margin');
% figure(99944)
% subplot1(size(posteriors_grid,1), size(posteriors_grid,2), 'Gap', [.01 .03], 'XTickL', 'Margin', 'YTickL', 'Margin');

figure(9995)
subplot1(size(posteriors_grid,1), size(posteriors_grid,2), 'Gap', [.01 .03], 'XTickL', 'Margin', 'YTickL', 'Margin');

for i = 1:size(posteriors_grid,1)
    for j = 1:size(posteriors_grid,2)
        
        if ~isempty(posteriors_grid{i,j})
            
            spatial_posteriors(i,j).amps = [];
            spatial_posteriors(i,j).num_events = [];
            spatial_posteriors(i,j).tau1 = [];
            spatial_posteriors(i,j).tau2 = [];
            spatial_posteriors(i,j).times = [];
            
            for ii = -neighborhood_size:neighborhood_size
                for jj = -neighborhood_size:neighborhood_size
                     if ~(i+ii < 1 || i+ii > size(posteriors_grid,1) || j+jj < 1 || j+jj > size(posteriors_grid,2))
                         
                         
                         spatial_posteriors(i,j).amps = [spatial_posteriors(i,j).amps [posteriors_grid{i+ii,j+jj}.amps]];
                         spatial_posteriors(i,j).num_events = [spatial_posteriors(i,j).num_events [posteriors_grid{i+ii,j+jj}.num_events]];
                         spatial_posteriors(i,j).tau1 = [spatial_posteriors(i,j).tau1 [posteriors_grid{i+ii,j+jj}.tau1]];
                         spatial_posteriors(i,j).tau2 = [spatial_posteriors(i,j).tau2 [posteriors_grid{i+ii,j+jj}.tau2]];
                         spatial_posteriors(i,j).times = [spatial_posteriors(i,j).times [posteriors_grid{i+ii,j+jj}.times]];
                         
                     end
                end
            end

%             figure(9991)
%             subplot(size(posteriors_grid,1),size(posteriors_grid,2),(i-1)*size(posteriors_grid,2) + j)
            (i-1)*size(posteriors_grid,2) + j
%             subplot1((i-1)*size(posteriors_grid,2) + j);
%             histogram(spatial_posteriors(i,j).amps)
%             axis off
%             ylim([0 10000])
%             xlim([20 250])
            
%             figure(9992)
%             subplot(size(posteriors_grid,1),size(posteriors_grid,2),(i-1)*size(posteriors_grid,2) + j)
%             subplot1((i-1)*size(posteriors_grid,2) + j);
%             histogram(spatial_posteriors(i,j).num_events)
%             axis off

%             ylim([0 10000])
%             xlim([0 7])
%             
%             figure(9993)
%             subplot(size(posteriors_grid,1),size(posteriors_grid,2),(i-1)*size(posteriors_grid,2) + j)
%             subplot1((i-1)*size(posteriors_grid,2) + j);
%             histogram(spatial_posteriors(i,j).tau1)
%             axis tight
%             axis off
%             ylim([0 10000])
%             xlim([5 50])
%             
%             figure(99944)
%             subplot(size(posteriors_grid,1),size(posteriors_grid,2),(i-1)*size(posteriors_grid,2) + j)
%             subplot1((i-1)*size(posteriors_grid,2) + j);
%             histogram(spatial_posteriors(i,j).tau2)
%             axis tight
%             axis off
%             ylim([0 10000])
%             xlim([30 200])
%             
            figure(9995)
%             subplot(size(posteriors_grid,1),size(posteriors_grid,2),(i-1)*size(posteriors_grid,2) + j)
            subplot1((i-1)*size(posteriors_grid,2) + j);
            histogram(spatial_posteriors(i,j).times)

            axis off
%             ylim([0 10000])
            xlim([0 .1]*20000)
            
        end
    end
end

% figure(9991)
% subplot1(1);
% title('amps')
% 
% figure(9992)
% subplot1(1)
% title('num events')

% figure(9993)
% subplot(size(posteriors_grid,1),size(posteriors_grid,2),1)
% histogram(spatial_posteriors(i,j).tau1)
% title('tau on')
% 
% figure(99944)
% subplot1(1)
% title('tau off')

figure(9995)
subplot1(1)
title('times')

    
    