import React, { useState } from 'react';
import Button from '@mui/material/Button';
import IconButton from '@mui/material/IconButton';
import Menu from '@mui/material/Menu';
import CancelIcon from '@mui/icons-material/Cancel';
import CheckCircleIcon from '@mui/icons-material/CheckCircle';
import Icon from '@mui/material/Icon';
import KeyboardArrowDownIcon from '@mui/icons-material/KeyboardArrowDown';
import DataObjectIcon from '@mui/icons-material/DataObject';
import MenuInstance from './MenuInstance';
import { red, lightGreen } from '@mui/material/colors';
import { collectValues,
         getCells,
         exposeColorsTableMain,
         exposeColorsTableQuant,
         updateCellsTableMain,
         updateCellsTableQuant,
         getPolarity,
         updateHighlights,
         getHeaderHighlights,
         getVariables } from '../util';

function MenuCell ({ explObj,
                     colorsTable,
                     cellsTable,
                     ts,
                     tp,
                     colGridIndex,
                     curCol,
                     predsLength,
                     dbsObjs,
                     highlights,
                     setMonitorState,
                     subfsScopes }) {

  // NestedMenuItem
  const [anchorEl, setAnchorEl] = useState(null);
  const open = Boolean(anchorEl);

  const handleFirstClick = (event) => setAnchorEl(event.currentTarget);
  const handleClose = () => setAnchorEl(null);

  const handleClick = (event, domainValues) => {

    if (explObj.type === "node") {

      let domainValuesAux = [...domainValues];

      let selCellsObj = getCells(explObj, domainValuesAux);

      domainValuesAux = [...domainValues];

      let variables = getVariables(explObj, domainValuesAux);

      console.log(variables);

      let action = { type: "updateColorsAndCellsTable",
                     colorsTable: exposeColorsTableMain(selCellsObj,
                                                        colorsTable.length,
                                                        colorsTable[0].length),
                     cellsTable: updateCellsTableMain(selCellsObj, cellsTable)
                   };
      setMonitorState(action);

    } else {
      if (explObj.type === "leaf") {
        let action = { type: "updateColorsAndCellsTable",
                       colorsTable: exposeColorsTableMain(explObj,
                                                          colorsTable.length,
                                                          colorsTable[0].length),
                       cellsTable: updateCellsTableMain(explObj, cellsTable)
                   };
        setMonitorState(action);
      } else {
        if (explObj.kind === "partition") {

          // Update path highlighting for the quantifiers case
          let selPartObj = getCells(explObj, domainValues);

          let cell = undefined;

          if (selPartObj.table !== undefined) {

            for (let i = 0; i < selPartObj.table.length; ++i) {
              if (selPartObj.table[i].tp === tp && selPartObj.table[i].col === curCol) {
                cell = selPartObj.table[i];
              }
            }

          }

          let children = [];

          for (let i = 0; i < cell.cells.length; ++i) {
            children.push({ tp: cell.cells[i].tp, col: cell.cells[i].col + predsLength, isHighlighted: false });
          }

          let newHighlights = updateHighlights(ts, tp, colGridIndex, cell, dbsObjs, highlights, children);

          // Update header highlights
          let newSubfsHeaderHighlights = getHeaderHighlights(curCol,
                                                             subfsScopes,
                                                             colorsTable.length);

          let action = { type: "updateColorsAndCellsTableAndHighlights",
                         colorsTable: exposeColorsTableQuant(selPartObj, curCol + 1, subfsScopes, colorsTable),
                         cellsTable: updateCellsTableQuant(selPartObj, curCol, cellsTable),
                         selectedRows: newHighlights.selectedRows,
                         highlightedCells: newHighlights.highlightedCells,
                         pathsMap: newHighlights.clonePathsMap,
                         subfsHeader: newSubfsHeaderHighlights
                       };

          setMonitorState(action);
        }
      }
    }

    setAnchorEl(null);

  };

  if (explObj.type === "leaf") {
    return (
      <div>
        { getPolarity(explObj, curCol) === "true" ?
          <IconButton style={{ minWidth: "80px" }}
                      onClick={handleClick}>
            <CheckCircleIcon fontSize="small" style={{ color: lightGreen[500] }}/>
            <Icon fontSize="small"/>
          </IconButton> : "" }

        { getPolarity(explObj, curCol) === "false" ?
          <IconButton style={{ minWidth: "80px" }}
                      onClick={handleClick}>
            <Icon fontSize="small"/>
            <CancelIcon fontSize="small" style={{ color: red[500] }}/>
          </IconButton> : "" }
      </div>
    );
  } else {
    if (explObj.type === "node" || explObj.kind === "partition") {
      return (
        <div>
          { getPolarity(explObj, curCol) === "true" ?
            <Button variant="text"
                    style={{ minWidth: "80px" }}
                    onClick={handleFirstClick}
            >
              <CheckCircleIcon fontSize="small" style={{ color: lightGreen[500] }}/>
              <Icon fontSize="small"/>
              <KeyboardArrowDownIcon fontSize="small" />
            </Button> : "" }

          { getPolarity(explObj, curCol) === "false" ?
            <Button variant="text"
                    style={{ minWidth: "80px" }}
                    onClick={handleFirstClick}
            >
              <Icon fontSize="small"/>
              <CancelIcon fontSize="small" style={{ color: red[500] }}/>
              <KeyboardArrowDownIcon fontSize="small" />
            </Button>
            : "" }

          { getPolarity(explObj, curCol) === "both" ?
            <Button variant="text"
                    style={{ minWidth: "80px" }}
                    onClick={handleFirstClick}
            >
              <CheckCircleIcon fontSize="small" style={{ color: lightGreen[500] }}/>
              <CancelIcon fontSize="small" style={{ color: red[500] }}/>
              <KeyboardArrowDownIcon fontSize="small" />
            </Button> : "" }
          <Menu anchorEl={anchorEl}
                open={open}
                onClose={handleClose}>
            <MenuInstance explObj={explObj}
                          curCol={curCol}
                          domainValues={[]}
                          open={open}
                          handleClose={handleClose}
                          handleClick={handleClick}/>
          </Menu>
        </div>
      );
    } else {
      return "";
    }
  }
}

export default MenuCell;
