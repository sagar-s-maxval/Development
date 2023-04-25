export {
    splitWidthString,
    createIndexMap,
    doSort,
    addNameUrlField,
    replaceDateType,
    makeSortable,
    overrideColumnWidths,
    replaceNameColumn
}

function splitWidthString(widthString, defaultWidth) {

    if (widthString && /^(\d*,*)+$/.test(widthString)) {
        return widthString.split(',')
            .map(width => Number(width) === 0 ?
                // "100,,100" => "100,DEFAULT_COLUMN_WIDTH,100"
                defaultWidth : Math.round(Number(width)));
    } else {
        return undefined;
    }

}

function doSort(value1, value2, sortedBy, sortDirection) {

    if (!sortedBy || !sortDirection) {
        return 0;
    }

    sortedBy = sortedBy === 'NameUrl' ? 'Name' : sortedBy;

    if (value1[sortedBy] === value2[sortedBy]) {
        return 0;
    }

    if (sortDirection === 'asc') {
        if (value1[sortedBy] === undefined) {
            return -1;
        }
        if (value2[sortedBy] === undefined) {
            return 1;
        }

        return value1[sortedBy] > value2[sortedBy] ? 1 : -1;
    }

    if (sortDirection === 'desc') {
        if (value1[sortedBy] === undefined) {
            return 1;
        }
        if (value2[sortedBy] === undefined) {
            return -1;
        }
        return value1[sortedBy] < value2[sortedBy] ? 1 : -1;
    }
}

function addNameUrlField(record, nameAsUrl) {
    let rec = {...record};
    if (nameAsUrl) {
        rec.NameUrl = `/${record.Id}`;
    }
    return rec;
}

function replaceDateType(column) {
    let res = {...column};

    res.type = res.type === 'date' ? 'date-local' : res.type;

    return res;
}

function makeSortable(column) {
    let res = {...column};

    res.sortable = true;

    return res;
}

function overrideColumnWidths(column, widths, DEFAULT_COLUMN_WIDTH, indexMap) {
    if (!widths) {
        return column;
    }

    let res = {...column};

    let index = indexMap.get(res.fieldName);

    // if there are more columns that widths specified
    res.initialWidth = widths[index] || DEFAULT_COLUMN_WIDTH;

    return res;
}

function replaceNameColumn(column, nameAsUrl) {
    if (nameAsUrl && column.fieldName === 'Name') {
        let res = {...column};

        res.type = 'url';
        res.fieldName = 'NameUrl';
        res.typeAttributes = {
            label: {
                fieldName: 'Name'
            },
            target: '_blank'
        }

        return res;
    } else {
        return column;
    }
}

function createIndexMap(columns) {
    let indexMap = new Map();

    for (let i = 0; i < columns.length; i++) {
        indexMap.set(columns[i].fieldName, i);

    }

    return indexMap;
}