function [numFrames, numFilasFrame, numColumnasFrame, FPS] = carga_video_entrada(videoInput)   
    numFrames = videoInput.NumFrames;
    numFilasFrame = videoInput.Height;
    numColumnasFrame = videoInput.Width;
    FPS = videoInput.FrameRate;
end