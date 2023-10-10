#!/usr/bin/env racket

#lang racket

(require odysseus)
(require tabtree)
(require tabtree/utils)
(require tabtree/sorters)
(require tabtree/output)

(define places_russia (parse-tabtree "/home/denis/data/settlements_kgr/source/main.tree"))

(define objects_with_location
  (t+
    (parse-tabtree "/home/denis/projects/milk_industry_kgr/source/facts/companies.tree")
    (parse-tabtree "/home/denis/projects/milk_industry_kgr/source/facts/factories.tree")
  ))

(define (get-place item)
  (or
    ($ place item)
    ($ city item)
    ($ hq item)
    ))

(define used_places_tabtree
  (let* ((used_places (->> objects_with_location hash-values (map get-place) flatten remove-duplicates)))
    (hash-filter (λ (id item) (index-of? used_places id)) places_russia)))

(write-file
  "/home/denis/projects/milk_industry_kgr/source/facts/places_russia.tree"
  (tabtree->string
    used_places_tabtree
    #:pars-print-order "name,lat,lon,pop"
    #:ignore-keys '("a" "country" "region")
    #:sorter id<))
