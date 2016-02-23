function infer_events(params)

if params.rand == 1
    rng(params.seed)
end



if ~isfield(params,'start_ind')
    params.start_ind = 1;
end

try
    load(params.traces_filename,'traces')
catch e
    params.traces_filename = 'data/for-paper/direct-stim-w-events-real.mat';
    load('data/for-paper/direct-stim-w-events-real.mat')
end

if ~isfield(params,'duration')
    params.duration = size(traces,2);
end

% the file were your traces are, traces should be saved in this mat file in
% an N x T matrix called 'traces' where N = number of traces and T = number
% of samples
% load(params.traces_filename,'traces');

if params.is_grid
    [traces, rebuild_map] = stack_traces(traces);
    params.rebuild_map = rebuild_map;
end

% assignin('base','rebuild_map',rebuild_map)
% return

% grab section in time
traces = traces(:,params.start_ind:(params.start_ind + params.duration - 1));

% grab subset of traces
if isfield(params,'traces_ind')
    traces = traces(params.traces_ind,:);
end

if params.tau1_min >= params.tau1_max || params.tau2_min >= params.tau2_max
    results = 'infeasible parameter set';
    params.savename = [params.savename(1:end-4) '-z.mat'];
    save(params.savename,'results')
    return
end

results = struct();
disp(['About to run inference on: ' num2str(size(traces,1)) ' traces...']);

if params.par
    
    if params.cluster

        addpath(genpath(params.source_path));

        maxNumCompThreads(12)
        matlabpool(12)

    else

        delete(gcp('nocreate'))
        this_pool = parpool();

    end
    
    parfor trace_ind = 1:size(traces,1)
    %     
        disp(['Starting trace #' num2str(trace_ind)])
        trace = params.event_sign*traces(trace_ind,:);
        trace = trace - min(trace);

        event_times_init = template_matching(-1*params.event_sign*traces(trace_ind,:), params.dt,...
            params.init_method.tau, params.init_method.amp_thresh, params.init_method.conv_thresh);

        tau = [mean([params.tau1_min params.tau1_max]) mean([params.tau2_min params.tau2_max])]/params.dt;

        if params.direct_stim
%             event_times_init = ceil(length(trace)*rand(1,length(trace)*params.p_spike));
            [results(trace_ind).trials, results(trace_ind).mcmc]  = sampleParams_ar_2taus_directstim(trace,tau,event_times_init,params);
        else
%             event_times_init = template_matching(-1*params.event_sign*traces(trace_ind,:), params.dt,...
%                 params.init_method.tau, params.init_method.amp_thresh, params.init_method.conv_thresh);
            [results(trace_ind).trials, results(trace_ind).mcmc]  = sampleParams_ARnoise_splittau(trace,tau,event_times_init,params);
        end

    end
    
    
    if params.cluster
        matlabpool close
    else
        delete(this_pool)
    end

else
    for trace_ind = 1:size(traces,1)
        disp(['Starting trace #' num2str(trace_ind)])
        trace = params.event_sign*traces(trace_ind,:);
        trace = trace - min(trace);

        event_times_init = template_matching(-1*params.event_sign*traces(trace_ind,:), params.dt,...
            params.init_method.tau, params.init_method.amp_thresh, params.init_method.conv_thresh);
        event_times_init = [];
        tau = [mean([params.tau1_min params.tau1_max]) mean([params.tau2_min params.tau2_max])]/params.dt;

        if params.direct_stim
%             event_times_init = ceil(length(trace)*rand(1,length(trace)*params.p_spike));
            [results(trace_ind).trials, results(trace_ind).mcmc]  = sampleParams_ar_2taus_directstim(trace,tau,event_times_init,params);
        else
            [results(trace_ind).trials, results(trace_ind).mcmc]  = sampleParams_ARnoise_splittau(trace,tau,event_times_init,params);
        end
    end
end

disp('finding min err...')
% map sample
for trace_ind = 1:size(traces,1);

    [results(trace_ind).map, results(trace_ind).map_ind] = max(results(trace_ind).trials.obj);
    
end

% if params.is_grid
%     results_grid = unstack_results(results, rebuild_map);
% end

% results = results_grid;

disp('saving...')
save(params.full_save_string,'results','params','-v7.3')

disp('done')


