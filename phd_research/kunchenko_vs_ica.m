%% build signal as sum of one of EEG lines and "roof" signal
load('dataset.mat')

amplitude = 2 * max(abs(dataset));
utilFunction = @(x)(amplitude - abs(x - amplitude - 2000));
additionalSignal = utilFunction(1:3000);
additionalSignal = additionalSignal .* (additionalSignal > 0);

signalToAnalyze = dataset + additionalSignal;

%% apply Kunchenko processing
template = utilFunction(2000:(2000 - 1 + 2 * round(amplitude)));
generatedFunctions = integerPowers(6);
[poly, ~, effectogram] = KunchenkoNew(signalToAnalyze, template, generatedFunctions);

%% apply FastICA processing
utilitySignal = -2 * dataset + additionalSignal;
c = fastica([signalToAnalyze; utilitySignal]);

%% plot input signals
figure('Color','white');
subplot(3,1,1);
plot(dataset);
ylabel('�������� ������');

subplot(3,1,2);
plot(additionalSignal);
ylabel('���������� ������');

subplot(3,1,3);
plot(signalToAnalyze);
ylabel('���� �������');
%% plot Kunchenko results
figure('Color','white');
subplot(3,1,1);
plot(signalToAnalyze);
ylabel('������ ��� ������');

subplot(3,1,2);
plot(poly);
ylabel('������ ��������');

subplot(3,1,3);
plot(effectogram);
ylabel('�����������');

%% plot FastICA results
figure('Color','white');
subplot(4,1,1);
plot(signalToAnalyze);
ylabel('������ ��� ������');

subplot(4,1,2);
plot(utilitySignal);
ylabel('���������� ������ ��� FastICA');

subplot(4,1,3);
plot(dataset);
ylabel('����������� ������');

subplot(4,1,4);
plot(c(2,:));
ylabel('³��������� ������');