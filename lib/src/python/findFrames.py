import os
import argparse
import cv2
import imagehash
from PIL import Image
import time
import json

#py -m pip install ImageHash

def main(input):

    # get file path for desired video and where to save frames locally
    cap = cv2.VideoCapture(input['input'])
    path_to_save = os.path.abspath(input['outputPath'])

    current_frame = 1
    current_hash = imagehash.average_hash(Image.open('./lib/assets/images/defaultImage.jpg'))

    cutoff = 5  # maximum bits that could be different between the hashes.
    screenShootsMetaData=[]

    if not cap.isOpened():
        print('Cap is not open')
    st = time.time()
    # cap opened successfully
    while cap.isOpened():
        # capture each frame
        ret, frame = cap.read()
        if ret == True:
            if current_hash - imagehash.average_hash(Image.fromarray(frame)) > cutoff:
                # Save frame as a jpg file
                name = 'screen' + str(current_frame) + '.jpg'
                screenShootsMetaData.append({
                    'number':current_frame,
                    'imageName':name,
                    'hashDifference': current_hash - imagehash.average_hash(Image.fromarray(frame)),
                    'path':os.path.join(path_to_save, name)
                })
                cv2.imwrite(os.path.join(path_to_save, name), frame)
                current_hash = imagehash.average_hash(Image.fromarray(frame))
                # keep track of how many images you end up with
                current_frame += 1
        else:
            break

    # release capture
    cap.release()

    elapsed_time = time.time() - st
    print('Execution time:', elapsed_time, 'seconds')

    return screenShootsMetaData

if __name__ == "__main__":
    parser = argparse.ArgumentParser()
    parser.add_argument("--uuid")
    args = parser.parse_args()
    stream_start = f"`S`T`R`E`A`M`{args.uuid}`S`T`A`R`T`"
    stream_end = f"`S`T`R`E`A`M`{args.uuid}`E`N`D`"
    while True:
        cmd = input()
        cmd = json.loads(cmd)
        try:
            result = main(cmd)
        except Exception as e:
            result = {"exception": e.__str__()}
        result = json.dumps(result)
        print(stream_start + result + stream_end)