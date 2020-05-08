#!bin/bash


#设置图片输出保存的路径

#  帮助文档
function Usage {
        echo "Usage:    bash work_1.sh [options]"
        echo "the options:"
        echo "-d        the directory of the pictures that you want to deal with"
        echo "-q        Support picture quality compression for jpeg format pictures"
        echo "-r        Support to compress the resolution of jpeg or png or svg format pictures while maintaining the original aspect ratio"
        echo "-w        Support to add custom text watermark to pictures in batch"
        echo "-p        add the prefix to rename the images"
        echo "-s        add the suffix to rename the images"
        echo "-c        To convert png/svg to jpeg files"
        echo "-h        Get the help"
}

#对jpeg格式图片进行图片质量压缩
function jpeg_compress {
       
        for p in "$1"*.jpg; do
                fullname=$(basename "$p")
                convert "$p" -quality "$2"% ./output/"$fullname"
		echo $p "quality compression success"
        done
}


#对jpeg/png/svg格式图片在保持原始宽高比的前提下压缩分辨率
function compress_resolution {
	
	for p in $(find "$1" -regex  '.*\.jpg\|.*\.svg\|.*\.png'); do
		fullname=$(basename "$p")
		convert "$p" -resize "$2" ./output/"$fullname"
		echo $p "compress resolution success"
	done
}

#对图片批量添加自定义文本水印
function add_watermark {
	for p in $(find "$1" -regex  '.*\.jpg\|.*\.svg\|.*\.png'); do
		fullname=$(basename "$p")
		convert "$p" -fill red -pointsize 40 -gravity center -draw "text 0,0 '$2' " ./output/"$fullname"
		echo $p "add watermark success"
	done
}	

#批量重命名（统一添加文件名前缀，不影响原始文件扩展名）
function add_prefix { 
	for p in "$1"*; do
		fullname=$(basename "$p")
		cp "$p" ./output/"$2""$fullname" 
		echo $p "add prefix success"
	done 
}

#批量重命名（统一添加文件名后缀，不影响原始文件扩展名）
function add_suffix {
        for p in "$1"*; do
		fullname=$(basename "$p")
		extension=${fullname##*.}
		filename=$(echo "$fullname" | cut -d . -f1)
		cp "$p" ./output/"$filename""$2"".""$extension"
		echo $p "add suffix success"
	done
}

#将png/svg图片统一转换为jpg格式图片
function convert_jpg {

	for p in $(find "$1" -regex '.*\.svg\|.*\.png');do	
		fullname=$(basename "$p")
	        filename=$(echo "$fullname" | cut -d . -f1)
		extension=$(echo "$fullname" | cut -d . -f2)
		convert "$p" ./output/"$filename"".jpg"
		echo $p "convert jpg success"
	done
}


# main

while [[ "$#" -ne 0 ]]; do
        case "$1" in
                "-d")
                        dir="$2"
                        shift 2
                        ;;

                "-q")
                        jpeg_compress "$dir" "$2"
                        shift 2
                        ;;

                "-r")
			compress_resolution "$dir" "$2"
                        shift 2
                        ;;

                "-w")
			add_watermark "$dir" "$2"
			 shift 2
                        ;;

                "-p")
			add_prefix "$dir" "$2"
                        shift 2
                        ;;

                "-s")
			add_suffix "$dir" "$2"
                        shift 2
                        ;;

                "-c")
			convert_jpg "$dir"
                        shift
                        ;;

                "-h")
                        Usage
                        shift
                        ;;
        esac
done
