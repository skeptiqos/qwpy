.page.data:(enlist 0Ni)!(enlist (`symbol$())!());

.page.getPTdata:{[table;setimes]
 dts: date where date within `date$setimes;
 data: raze { [table;dt]
  `..INFO("reading partition %1 into cache";enlist dt);
  hsym[`$string dt] table
  }[table]each dts;
 data
 };

.page.getTdata:.page.getPTdata[`t]

/ read all data and sort by field
.page.read:{[query;params;sortcols]
 `..INFO(".page.read for querycall:%1 sortcols:%2";((query;params);sortcols));
 data: value (query;params);
 `..INFO("sorting %1 records by :%2";(count data; sortcols));
 data: sortcols xasc data;
 `..INFO(".page.read - returning %1 records";enlist count data);
 data
 };

.page.cache:{[handle;query;params;sortcols]
 if[not count .page.data . queryid:(handle;query);
  `..INFO(".page.cache: updating cache for %1";enlist queryid);
  .[`.page.data;queryid;:;] .page.read[query;params;sortcols];
  `..INFO".page.cache - done";
  ];
  .page.data . queryid
 };

.page.clearcache:{[handle;query]
 `..INFO(".page.clearcache: %1";queryid:(handle;query));
 .[`.page.data;queryid;:;()];
 `..INFO".page.clearcache - done";
 };

.page.batchIterator:{[qpmdict;offset;limit]
 `..INFO(".page.batchIterator: %1 offset:%2 limit:%3";(qpmdict;offset;limit));
 data: .page.cache[.z.w;qpmdict`query;qpmdict`setimes;qpmdict`sortcols];
 rdata: {(count[y]&x)#y}[limit]offset _ data;
 hasnext:1b;
 if[count[data]<=limit+offset;
  hasnext:0b;
  .page.clearcache[.z.w;qpmdict`query];
  ];
 `..INFO(".page.batchIterator - returning %1 records, hasnext:%2 : %3";(count rdata;hasnext;rdata));
 `data`hasnext!(rdata;hasnext)
 };


\
// pagination
/create data
n:floor 1e06;t:([]sym:n?`3;p:n?100f;a:n?("abc";"defh";"hijk";"lm";"nopqrs";"tuv";"xyz");n:.j.j each n#enlist 1000*`a`b`c`d`e`f`h`g!til 8);
\t {.Q.dpft[`:db;.z.d-x;`sym;`t]}each til 3;

/client
(`.page.batchIterator;`query`setimes`sortcols!(`.page.getTdata;2021.02.12 2021.02.12;`a);0;10)
