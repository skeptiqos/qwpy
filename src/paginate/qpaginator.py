import numpy


class QPaginator:

    def __init__(self, qcon, querydict, batchsize):
        self.offset = 0
        self.hasnext = True
        self.limit = batchsize
        self.querydict = querydict
        self.qcon = qcon

    def __iter__(self):
        return self

    def __next__(self):
        if self.hasnext:
            batch = self.qcon.sendSync(numpy.string_('.page.batchIterator'), self.querydict, self.offset, self.limit)
            self.hasnext = batch[numpy.bytes_('hasnext')]
            self.offset += self.limit
            return batch
        else:
            raise StopIteration
