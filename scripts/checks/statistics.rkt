#!/usr/bin/env racket

#lang racket

(require odysseus)
(require tabtree)
(require tabtree/utils)
(require tabtree/sorters)

(define places_russia_tt (parse-tabtree "/home/denis/projects/milk_industry_kgr/source/facts/places_russia.tree"))
(define factories_russia_tt (parse-tabtree "/home/denis/projects/milk_industry_kgr/source/facts/factories.tree"))

(define total-population (->> places_russia_tt hash-values (map (λ (item) (->number (hash-ref item "pop" "0")))) (apply +)))
(define total-workers (->> factories_russia_tt hash-values (filter-not (λ (item) ($ end item))) (map (extend-numeric "w" min)) (apply +)))

(--- "Total workers in the milk industry (from factories.tree): " (format-number "dd.ddd.ddd" (->int total-workers)))
