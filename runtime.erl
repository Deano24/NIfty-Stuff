%% @author Deano24
%% @desc Erlang application to test the run time of erlang for either counting numbers or reading and writing a file line by line


-module(easy).
-export([time_check/1,app_start/0,second_app_start/0,readlines/0]).

%=========================================================
%@desc Checks the run time of erlang to count to 100,000 
%==========================================================

%
%@desc Starts the timer (timer is in microseconds) and calls the function passing in the starting digit
%
app_start()-> timer:tc(easy,time_check,[0]).

%
%@desc Recurively adds 1 to the current number until you reach the desired number
%
%@param Number the Number it is currently at
%
time_check(Number) when Number < 100000->
	time_check(Number+1);
time_check(100000)->1
.

%========================================================================================
%@desc Checks the run time of Erlang opening a file and moving its contents to a next file
%============================================================================================

%
%@desc Starts the timer (timer is in microseconds) passing in the function to call and its arguments in this case none
%
second_app_start()->timer:tc(easy,readlines,[]).

%
%@desc Opens both files and the calls the function that does the reading, after this closes both files.
%
readlines()->
    {ok, Device} = file:open("C:\\Users\\Deano\\Documents\\test\\dummy.txt", [read]),
    {ok, IODevice} = file:open("C:\\Users\\Deano\\Documents\\test\\ErlangDummy.txt", [append]),
    read_chunks(Device,1048576,IODevice),
    file:close(Device),
    file:close(IODevice)
.

%
%@desc Uses file:read to read a certain amount of bytes from the file and spawn 
%a function to handly the data and recursively call itself to read next set of bytes until file is empty
%
%@param Device file to read from
%@param Size amount of bytes to be read
%@param IODevice file to be written to
%
read_chunks(Device,Size,IODevice)->
	case file:read(Device, Size) of
		eof  -> 1;
		{ok , Data} -> spawn(fun () -> get_all_lines_data(Data,IODevice) end),read_chunks(Device,Size,IODevice);
		{error, _}->1
	end
.

%
%@desc Writes passed data to file
%
%@param Data the data to be written
%@param IODevice file to be written to
%
get_all_lines_data(Data,IODevice) ->
	file:write(IODevice, Data)
.