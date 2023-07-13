import DataTable from 'react-data-table-component';
import React, {useEffect, useState} from 'react';
import {useUserContext} from "../../context/UserContext";
import ReactPlayer from "react-player";
import {downloadCSV, customStyles, FilterComponent} from './tableUtils';


const columns = [
    {
        name: "Id",
        selector: row => row.id,
        width:"100px"
    },
    {
        name: 'Name',
        selector: row => row.name,
        width:"330px"

    },
    {
        name: 'Channel ID',
        selector: row => row.channel_id,
        width:"140px"

    },
    {
        name: "View Count",
        selector: row => row.view_count,
        width:"140px"

    },
    {
        name: "Description",
        selector: row => row.description,
    },

];


const ExpandedComponent = ({data}) => {

    return <div style={{

        margin: "10px 20px"
    }}>
        <div style={{height: "50px"}}>
            <div style={{display: "flex", height: "40px", justifyContent: "end"}}>
                <button>
                    Disable
                </button>
                <div style={{width: "50px"}}></div>
                <button>
                    Disable
                </button>

            </div>

        </div>
        <div style={{
            display: "flex",
            alignContent: "center",
            justifyContent: "space-between",
            width: "100%",
            height: "400px",
        }}>
            <div><img style={{objectFit: 'contain', maxHeight: "360px"}}
                      src={'http://0.0.0.0:8000/storage/' + data.banner_url}></img></div>
            <div>
                <ReactPlayer style={{width: "600px", height: "400px", objectFit: "fill"}}
                             controls={true}
                             url={'http://0.0.0.0:8000/storage/' + data.file_url}></ReactPlayer>
            </div>
        </div>
    </div>
}


const VideosTables = ({}) => {

    const user = useUserContext();

    const [videos, setVideos] = useState([])
    const [filterText, setFilterText] = React.useState('');
    const [resetPaginationToggle, setResetPaginationToggle] = React.useState(false);

    const filteredItems = videos.filter(
        item => item.name && item.name.toLowerCase().includes(filterText.toLowerCase()),
    );
    const subHeaderComponentMemo = React.useMemo(() => {
        const handleClear = () => {
            if (filterText) {
                setResetPaginationToggle(!resetPaginationToggle);
                setFilterText('');
            }
        };

        return (
            <FilterComponent onFilter={e => setFilterText(e.target.value)} onClear={handleClear}
                             filterText={filterText}/>
        );
    }, [filterText, resetPaginationToggle]);

    const fetchData = () => {
        user.getAllVideos()
            .then(response => {
                return response;
            })
            .then(data => {
                setVideos(data)
            })
    }

    useEffect(() => {
        fetchData()
    }, [])


    const keys = ["id", "name", "channel_id", "description", "view_count"];

    const Export = ({onExport}) => <button onClick={e => onExport(e.target, keys)}>Export
        </button>
    ;

    const actionsMemo = <Export onExport={() => downloadCSV(videos, keys, "videos.csv")}/>;

    return <DataTable
        pagination
        columns={columns}
        data={filteredItems}
        actions={actionsMemo}
        expandableRows
        expandableRowsComponent={ExpandedComponent}
        customStyles={customStyles}
        paginationResetDefaultPage={resetPaginationToggle}
        highlightOnHover
        pointerOnHover
        subHeader
		subHeaderComponent={subHeaderComponentMemo}

    />
}

export default VideosTables;