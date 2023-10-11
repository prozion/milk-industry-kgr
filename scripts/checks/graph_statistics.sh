#! /usr/bin/bash

kgr=/home/denis/projects/milk_industry_kgr

arq --data $kgr/turtle/milk_industry.ttl --query $kgr/sparql/kgr_stat.rq
