
if ~isempty(instrfind)
 fclose(instrfind);
  delete(instrfind);
end
s = serial('COM4','BaudRate',9600,'DataBits',8,'Terminator','CR/LF');
%Initialize the serial port config
%get(s,{'BaudRate','DataBits','Parity','StopBits','Terminator'})
fopen(s);

%Variables
i=1;
adc_size = 4096;
fft_size = 2048;
wait_init = 1;
read_adc = 0;
read_fft = 0;
collect_data = 1;
%Create adc and fft arrays
adc_data = zeros(1,adc_size);
fft_data = zeros(1,fft_size);
adc_x = 0:4095;
fft_x = 0:2047;
%check adc sample array size in the project code

while(collect_data == 1)
    ser_data = fscanf(s,'%s');
    %fprintf(ser_data);
    if(strcmp(ser_data,'Init'))
        read_adc = 1;
        fprintf('Got Init\n');
    elseif(strcmp(ser_data,'FFT'))
        read_adc = 0;
        read_fft = 1;
        i = 1;
        fprintf('Start FFT\n');
    elseif(strcmp(ser_data,'DONE'))
        collect_data = 0;
        fprintf('FFT is done\n');    
    elseif(read_adc == 1)
        adc_data(i) = str2double(ser_data);
        fprintf('%d \n', i);
        i = i + 1;
    elseif(read_fft == 1)
        fft_data(i) = str2double(ser_data);
        fprintf('%d \n', i);
        i = i + 1;
    end
end

subplot(2,1,1);
plot(adc_x,adc_data,'k');
subplot(2,1,2);
stem(fft_x,fft_data,'filled','markersize',4);
fclose(s);
