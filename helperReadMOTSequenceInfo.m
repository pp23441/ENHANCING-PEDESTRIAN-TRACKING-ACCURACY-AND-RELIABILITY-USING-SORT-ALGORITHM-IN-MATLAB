function seqinfo = helperReadMOTSequenceInfo(filename)

fid = fopen(filename);
try
    fgetl(fid);%'{sequence}
    nameStrings = split(string(fgetl(fid)),'=');
    imPathStrings = split(string(fgetl(fid)),'=');
    frameRateStrings = split(string(fgetl(fid)),'=');
    seqLengthStrings = split(string(fgetl(fid)),'=');
    imWidthStrings = split(string(fgetl(fid)),'=');
    imHeightStrings = split(string(fgetl(fid)),'=');
    imExtStrings = split(string(fgetl(fid)),'=');

    seqinfo.FrameRate = str2double(frameRateStrings(end));
    seqinfo.SequenceLength = str2double(seqLengthStrings(end));
    seqinfo.ImageWidth = str2double(imWidthStrings(end));
    seqinfo.ImageHeight = str2double(imHeightStrings(end));
    seqinfo.ImageExtension = imExtStrings(end);
    seqinfo.ImagePath = nameStrings(end)+filesep+imPathStrings(end)+filesep;
    
    fclose(fid);
catch ME
    fclose(fid);
    rethrow(ME);
end
