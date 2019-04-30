#!/bin/bash

for taxon in 630921 1654716 375
do
  docker run -it -v "$PWD":/Public --rm  pyani \
    genbank_get_genomes_by_taxon.py \
    -o $taxon \
    -v \
    -t $taxon \
    -l $taxon.log \
  	-f \
    --email teo.decarvalho@gmail.com
  #echo $taxon.log
done

mkdir all

for taxon in 630921 1654716 375
do
  cp ./$taxon/*.fna all
done

# Para essa proxima etapa funcionar
# e necessario colocar previamente um
# arquivo chamado target.fna com a sequencia
# a ser buscada

wget -O target.fna https://www.dropbox.com/s/0hf8dwkps9z7zsb/target.fna?dl=1

cat all/*.fna > all.fna


docker run -it -v "$PWD":/Public --rm  pyani makeblastdb -in all.fna -dbtype nucl -out brady

docker run -it -v "$PWD":/Public --rm  pyani blastn -query target.fna -db brady -out resultado.txt -outfmt 7


