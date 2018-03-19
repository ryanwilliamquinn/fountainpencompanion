import { deleteRequest, getRequest } from "src/fetch";

export const DATA_RECEIVED = "DATA_RECEIVED";
export const DELETE_ENTRY = "DELETE_ENTRY";
export const FILTER_DATA = "FILTER_DATA";
export const LOADING_DATA = "LOADING_DATA";
export const TOGGLE_FIELD = "TOGGLE_FIELD";
export const UPDATE_FILTER = "UPDATE_FILTER";

export const dataReceived = data => ({type: DATA_RECEIVED, data});
export const filterData = () => ({type: FILTER_DATA});
export const loadingData = () => ({type: LOADING_DATA});
export const updateFilter = (data) => ({
  type: UPDATE_FILTER,
  ...data
});

export const deleteEntry = (id) => dispatch => {
  dispatch({type: DELETE_ENTRY, id});
  deleteRequest(`/collected_inks/${id}`);
  dispatch(filterData());
}
export const fetchData = () => dispatch => {
  dispatch(loadingData());
  return getRequest("/collected_inks").then(
    response => response.json()
  ).then(
    json => dispatch(dataReceived(json))
  )
}

export const toggleField = (fieldName, id) => ({type: TOGGLE_FIELD, fieldName, id});

export const togglePrivacy = (id) => (dispatch, getState) => {
  dispatch(toggleField("private", id));
  dispatch(filterData());
}

export const toggleSwabbed = (id) => (dispatch, getState) => {
  dispatch(toggleField("swabbed", id));
  dispatch(filterData());
}

export const toggleUsed = (id) => (dispatch, getState) => {
  dispatch(toggleField("used", id));
  dispatch(filterData());
}

export const updateFilterAndRecalculate = (data) => dispatch => {
  dispatch(updateFilter(data));
  dispatch(filterData());
}
