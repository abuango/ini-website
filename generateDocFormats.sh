#!/bin/sh

doindent()
{
  # Do a small indent depending on how deep into the tree we are
  # Depending on your enviroment, you may need to use
  # echo "  \c" instead of
  # echo -en "  "
    j=0;
    while [ "$j" -lt "$1" ]; do
      #echo -en "  " 
      j=`expr $j + 1`
    done
}

traverse() 
{
  # Traverse a directory
  indent="$2"

  ls "$1" | while read i
  do
    doindent $2
    if [ -d "$1/$i" ]; then
      echo "Directory: $1/$i"
      # Calling this as a subshell means that when the called
      # function changes directory, it will not affect our
      # current working directory
      traverse "$1/$i" `expr $2 + 1`
    else 
        if [ "$i" = "index.custom" ]; then
            echo "File: $1/$i"
            ./bin/pandoc -f html -t pdf --pdf-engine=wkhtmltopdf -s "$1/$i" -o "$1/inclusive-naming-word-lists-v1.0.pdf"
            ./bin/pandoc -f html -t html -s "$1/$i" -o "$1/inclusive-naming-word-lists-v1.0.html"
            ./bin/pandoc -f html -t odt -s "$1/$i" -o "$1/inclusive-naming-word-lists-v1.0.odt"
        fi
    fi
  done
}

if [ -z "$1" ]; then
  traverse . 0
else
  traverse "$1" 0
fi