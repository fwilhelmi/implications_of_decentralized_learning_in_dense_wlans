%%% **********************************************************************
%%% * Implications of Decentralized Learning in Dense WLANs              *
%%% *    - Submission to 1st workship of FG-ML5G                         *
%%% * Author: Francesc Wilhelmi (francisco.wilhelmi@upf.edu)             *
%%% * Co-Authors: B. Bellalta, C. Cano, A. Jonsson                       *
%%% * Copyright (C) 2017-2022, and GNU GPLd, by Francesc Wilhelmi        *
%%% * GitHub home: https://github.com/fwilhelmi                          *
%%% * Repository: implications_of_decentralized_learning_in_dense_wlans  *
%%% **********************************************************************

% FUNCTION THAT PLOTS THE RESULTS OF LEARNING AMONG LEGACY NODES
function [] = plot_results(tptEvolutionPerWlanContainer, legacy_percentage, legacy_list)

% The tptEvolutionPerWlanContainer must contain, for each approach (A), a set
% of structs in which the throughput evolution per node is displayed
% according to the scenario (S) and the number of legacy nodes (L)
% Henceforth, tptEvolutionPerWlanContainer is a A x S x L struct

    constants_ctmn
    constants_mabs
    system_conf 

%     if saveConsoleLogsEgreedy
%         diary(['./Output/console_logs' endTextOutputFile '.txt']) % Save logs in a text file
%     end
    
    numberOfApproaches = size(tptEvolutionPerWlanContainer, 2);  
    numberOfLegacyTests = size(legacy_percentage, 2);
     
    display_results_agg_tpt = zeros(numberOfApproaches, numberOfLegacyTests);
    display_results_std_agg_tpt = zeros(numberOfApproaches, numberOfLegacyTests);
    display_results_fairness = zeros(numberOfApproaches, numberOfLegacyTests);
    %display_results_std_fairness = zeros(numberOfApproaches, numberOfLegacyTests);
    
    numberOfScenarios = 1;
    
%     for a = 1 : numberOfApproaches
%     
%         average_agg_tpt = zeros(numberOfScenarios, numberOfLegacyTests);
%         average_mean_tpt = zeros(numberOfScenarios, numberOfLegacyTests);
%         average_std_tpt = zeros(numberOfScenarios, numberOfLegacyTests);
%         average_fairness = zeros(numberOfScenarios, numberOfLegacyTests);
%         average_std_fairness = zeros(numberOfScenarios, numberOfLegacyTests);
% 
%         % Independent results according to percentage of legacy nodes
%         for p = 1 : numberOfLegacyTests
% 
%             % Compute average performance among scenarios
%             for s = 1 : numberOfScenarios
% 
%                 % Throughput evolution
%                 average_agg_tpt(s, p) = mean(sum(tptEvolutionPerWlanContainer{a}{p, s}, 2));
%                 average_mean_tpt(s, p) = mean(mean(tptEvolutionPerWlanContainer{a}{p, s}, 2));
%                 average_std_tpt(s, p) = mean(std(tptEvolutionPerWlanContainer{a}{p, s}'));
% 
%                 % Fairness evolution
%                 average_fairness(s,p) = mean(jains_fairness(tptEvolutionPerWlanContainer{a}{p, s}));
%                 average_std_fairness(s,p) = std(jains_fairness(tptEvolutionPerWlanContainer{a}{p, s}));
% 
%             end
% 
%         end
%         
%         display_results_agg_tpt(a, :) = mean(average_agg_tpt); 
%         display_results_std_agg_tpt(a, :) = std(average_agg_tpt); 
%         display_results_fairness(a, :) = jains_fairness(average_agg_tpt'); 
%         %display_results_std_fairness(a, :) = mean(average_agg_tpt);        
%         
%     end
    
    
   
        average_agg_tpt = zeros(numberOfScenarios, numberOfLegacyTests);
        average_mean_tpt = zeros(numberOfScenarios, numberOfLegacyTests);
        average_std_tpt = zeros(numberOfScenarios, numberOfLegacyTests);
        average_fairness = zeros(numberOfScenarios, numberOfLegacyTests);
        average_std_fairness = zeros(numberOfScenarios, numberOfLegacyTests);

        % Independent results according to percentage of legacy nodes
        for p = 1 : numberOfLegacyTests

            % Compute average performance among scenarios
            for s = 1 : numberOfScenarios

                % Throughput evolution
                average_agg_tpt(s, p) = mean(sum(tptEvolutionPerWlanContainer{p, s}, 2));
                average_mean_tpt(s, p) = mean(mean(tptEvolutionPerWlanContainer{p, s}, 2));
                average_std_tpt(s, p) = mean(std(tptEvolutionPerWlanContainer{p, s}'));

                % Fairness evolution
                average_fairness(s,p) = mean(jains_fairness(tptEvolutionPerWlanContainer{p, s}));
                average_std_fairness(s,p) = std(jains_fairness(tptEvolutionPerWlanContainer{p, s}));

            end

        end
        
        display_results_agg_tpt(1, :) = mean(average_agg_tpt); 
        display_results_std_agg_tpt(1, :) = std(average_agg_tpt); 
        display_results_fairness(1, :) = jains_fairness(average_agg_tpt'); 
        %display_results_std_fairness(a, :) = mean(average_agg_tpt);        
            
    % ONLY REQUIRED average_agg_tpt OR average_mean_tpt AND
    % average_fairness FOR EACH LEARNING APPROACH
    
%     
%     
%     %% PLOT BARS AGGREGATE THROUGHPUT    
%     % Set font type
%     set(0,'defaultUicontrolFontName','Times New Roman');
%     set(0,'defaultUitableFontName','Times New Roman');
%     set(0,'defaultAxesFontName','Times New Roman');
%     set(0,'defaultTextFontName','Times New Roman');
%     set(0,'defaultUipanelFontName','Times New Roman');    
%     
%     ctrs = 1 : numberOfLegacyTests;
% 	data = display_results_agg_tpt;    
%     fig = figure('pos',[450 400 500 350]);
%     axes;
%     axis([1 20 30 70]);
%     hBar = bar(ctrs, display_results_agg_tpt');
%     for k1 = 1:size(display_results_agg_tpt, 1)
%         ctr(k1,:) = bsxfun(@plus, hBar(1).XData, [hBar(k1).XOffset]');
%         ydt(k1,:) = hBar(k1).YData;
%     end
%     hold on
%     errorbar(ctr, ydt, display_results_std_agg_tpt, '.r')
%     hold off    
%     %legend({'Selfish', 'Cooperative (disregarding)', 'Cooperative (regarding)'})
%     xlabel('Legacy nodes (%)')
%     xticks(1:4)
%     xticklabels(legacy_percentage*100)
%     ylabel('Av. aggregate throughput (Mbps)')
%     set(gca,'FontSize', 22)
%     
%     figName = ['bars_agg_tpt_' endTextOutputFile];
%     savefig(['./Output/' figName '.fig'])
%     saveas(gcf,['./Output/' figName],'epsc')
%     
%     
%     %% TEMPORAL AGGREGATE THROUGHPUT FOR EACH NUMBER OF LEGACY PERCENTAGE (ONLY ONE SCENARIO!)
%     for i = 1 : numberOfLegacyTests
%         fig = figure('pos',[450 400 500 350]);
%         axes;
%         axis([1 20 30 70]);
%         plot(sum(tptEvolutionPerWlanContainer{i}'))
%         title(['Legacy nodes (' num2str(legacy_percentage(i)*100) '%)'])
%         xlabel('Iteration')
%         ylabel('Av. aggregate throughput (Mbps)')
%         set(gca,'FontSize', 22)
%         figName = ['temporal_agg_tpt_' num2str(legacy_percentage(i)*100) '_legacy_' endTextOutputFile];
%         savefig(['./Output/' figName '.fig'])
%         saveas(gcf,['./Output/' figName],'epsc')
%     end
%     
%     %% INDIVIDUAL THROUGHPUT (ONLY ONE SCENARIO!)
%     for l = 1 : numberOfLegacyTests  
%         figure
%         title(['Legacy nodes (' num2str(legacy_percentage(l)*100) '%)'])
%       	for i = 1 : 8  
%             subplot(4,2,i)
%             plot(1:500,tptEvolutionPerWlanContainer{l}(:,i))
%             %title(['Legacy nodes (' num2str(legacy_percentage(i)*100) '%)'])
%             xlabel('Iteration')
%             ylabel('Throughput (Mbps)')
%             title(['WLAN ' num2str(i)])
%             %set(gca,'FontSize', 22)    
%         end        
%         figName = ['temporal_ind_tpt_' num2str(legacy_percentage(l)*100) '_legacy_' endTextOutputFile];
%         savefig(['./Output/' figName '.fig'])
%         saveas(gcf,['./Output/' figName],'epsc')
%     end
    
    %% LEARNING VS LEGACY PERFORMANCE
    % temporal average throughput evolution for both type of devices
    mean_tpt_per_iteration_legacy = zeros(numberOfLegacyTests,500);
    mean_tpt_per_iteration_learning = zeros(numberOfLegacyTests,500);
    
    % Compute the average throughput in each iteration
    figure
    for l = 1 : numberOfLegacyTests 
        for i = 1 : 500
            legacy_tpt_array = 0;
            learning_tpt_array = 0;
            for n = 1 : 8
                if legacy_list(l,n)
                    legacy_tpt_array = [legacy_tpt_array tptEvolutionPerWlanContainer{l}(i,n)];
                else
                    learning_tpt_array = [learning_tpt_array tptEvolutionPerWlanContainer{l}(i,n)];
                end
            end
            mean_tpt_per_iteration_legacy(l,i) = mean(legacy_tpt_array);
            mean_tpt_per_iteration_learning(l,i) = mean(learning_tpt_array);
        end        
        subplot(2,2,l)
        plot(1:500, mean_tpt_per_iteration_legacy(l,:))
        hold on
        plot(1:500, mean_tpt_per_iteration_learning(l,:))
        axis([0 500 0 120])
        title(['Legacy nodes (' num2str(legacy_percentage(l)*100) '%)'])
        legend({'Legacy devices', 'Learning devices'})
        ylabel('Av. throughput (Mbps)')
        xlabel('Iteration')
        set(gca,'FontSize', 20)
        figName = ['learning_vs_legacy_' num2str(legacy_percentage(l)*100) '_legacy_' endTextOutputFile];
        savefig(['./Output/' figName '.fig'])
        saveas(gcf,['./Output/' figName],'epsc')
    end
    
    
    
    %% REGRET

%     hold on
%     errorbar(1:numberOfLegacyTests, display_results_agg_tpt, display_results_std_agg_tpt,'.')
    
    %% PLOT BARS FAIRNESS
    
    %%
%     
% 
%     meanAggregateThroughput = num2str(mean(sum(tptEvolutionPerWlan(minimumIterationToConsider:totalIterations, :),2)));
%     meanFairness = num2str(mean(jains_fairness(tptEvolutionPerWlan(minimumIterationToConsider:totalIterations, :))));
%     meanProportionalFairness = num2str(mean(sum(log(tptEvolutionPerWlan(minimumIterationToConsider:totalIterations, :)),2)));
%     
%     disp(['Aggregate throughput experienced on average: ' meanAggregateThroughput ' Mbps'])
%     disp(['Fairness on average: ' meanFairness])
%     disp(['Proportional fairness experienced on average: ' meanProportionalFairness])
% 
%     nWlans = size(wlans, 2);
% 
%     % Throughput experienced by each WLAN for each e-greedy iteration
%     fig = figure('pos',[450 400 500 350]);
%     axes;
%     axis([1 20 30 70]);
%     for i = 1 : nWlans
%         subplot(nWlans/2, nWlans/2, i)
%         throughputPerIteration = tptEvolutionPerWlan(minimumIterationToConsider:totalIterations, i);
%         plot(minimumIterationToConsider:totalIterations, throughputPerIteration);
%         title(['WN ' num2str(i)]);
%         set(gca, 'FontSize', 18)
%         axis([minimumIterationToConsider totalIterations 0 1.1 * max(throughputPerIteration)])
%         grid on
%         grid minor
%     end
%     %xlabel('e-greedy Iteration', 'fontsize', 24)
%     ylabel('Throughput experienced (Mbps)', 'fontsize', 24)
%     % Save Figure
%     figName = ['./Output/temporal_tpt_' endTextOutputFile];
%     savefig(fig, figName);
%     
% %     fig_name = ['temporal_tpt_' end_text_output_file];
% %     savefig(['./Code/Experiments/e-greedy Experiments/Results Experiment 1/' fig_name '.fig'])
% %     saveas(gcf,['./Code/Experiments/e-greedy Experiments/Results Experiment 1/' fig_name],'epsc')
% 
%     % % Aggregated throughput experienced for each e-greedy iteration
%     % figure('pos',[450 400 500 350])
%     % axes;
%     % axis([1 20 30 70]);
%     % agg_tpt_per_iteration = sum(tpt_evolution_per_wlan_eg(minimumIterationToConsider:totalIterations, :), 2);
%     % plot(minimumIterationToConsider:totalIterations, agg_tpt_per_iteration)
%     % set(gca, 'FontSize', 22)
%     % xlabel('e-greedy Iteration', 'fontsize', 24)
%     % ylabel('Network Throughput (Mbps)', 'fontsize', 24)
%     % axis([minimumIterationToConsider totalIterations 0 1.1 * max(agg_tpt_per_iteration)])
%     % 
%     % % Proportional fairness experienced for each e-greedy iteration
%     % figure('pos',[450 400 500 350])
%     % axes;
%     % axis([1 20 30 70]);
%     % proprotional_fairness_per_iteration = sum(log(tpt_evolution_per_wlan_eg(minimumIterationToConsider:totalIterations,:)), 2);
%     % plot(minimumIterationToConsider:totalIterations, proprotional_fairness_per_iteration)
%     % set(gca, 'FontSize', 22)
%     % xlabel('e-greedy Iteration', 'fontsize', 24)
%     % ylabel('Proportional Fairness', 'fontsize', 24)
%     % axis([minimumIterationToConsider totalIterations 0 1.1 * max(proprotional_fairness_per_iteration)])
%     % saveas(gcf,'mean_tpt_per_wlan','epsc')
% 
%     % Average tpt experienced per WLAN
%     minimumIterationToConsider = totalIterations/2 + 1;
%     meanThroughputPerWlan = mean(tptEvolutionPerWlan(minimumIterationToConsider:totalIterations,:),1);
%     meanStdPerWlan = std(tptEvolutionPerWlan(minimumIterationToConsider:totalIterations,:),1);
%     figure('pos',[450 400 500 350])
%     axes;
%     axis([1 20 30 70]);
%     bar(meanThroughputPerWlan, 0.5)
%     set(gca, 'FontSize', 22)
%     xlabel('WN id','fontsize', 24)
%     ylabel('Mean throughput (Mbps)','fontsize', 24)
%     hold on
%     errorbar(meanThroughputPerWlan, meanStdPerWlan, '.r');
%     grid on
%     grid minor
%     % Save Figure
%     figName = ['mean_tpt_' endTextOutputFile];
%     savefig(['./Output/' figName '.fig'])
%     saveas(gcf,['./Output/' figName],'epsc')
%     
% end