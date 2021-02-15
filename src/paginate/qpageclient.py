
from qpython.qconnection import QConnection
from qpython import qcollection
from qpython.qcollection import QDictionary,qlist
import numpy
import os
import sys
sys.path.append(os.environ['HOME']+'/Code/src/qwpy/src/paginate/')
from qpaginator import QPaginator

q=QConnection('localhost',5000)
q.open()
print(q.is_connected())

dates=[ numpy.datetime64('2021-02-12','D'),numpy.datetime64('2021-02-12','D')]

querydict=QDictionary(
    qlist(numpy.array(['query', 'setimes', 'sortcols']), qtype=qcollection.QSYMBOL_LIST),
    [numpy.string_('.page.getTdata'),
     qlist( dates, qtype=qcollection.QDATE_LIST),
     numpy.string_('a')]
)

qpage = QPaginator(q, querydict, 999999)
qiter=iter(qpage)

print(qiter)

for batch in qiter:
    print('iteration:')
    print(batch[numpy.bytes_('data')])