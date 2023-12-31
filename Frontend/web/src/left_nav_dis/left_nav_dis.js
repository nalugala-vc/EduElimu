import React from 'react';
import {AiOutlineHeart,AiOutlineCloudDownload,AiOutlineSetting,AiOutlineLike,AiOutlineClose} from 'react-icons/ai';
import {MdOutlineBrowseGallery} from 'react-icons/md';
import {BsBrowserEdge} from 'react-icons/bs';
import {TbLogout} from 'react-icons/tb';
import {SlGameController} from 'react-icons/sl';
import './left_nav_dis.css'

function LeftNavDis({toggleLeftNav}){
    return <div className='left-nav'>
    <h2>EduElimu. <AiOutlineClose id='close' onClick={toggleLeftNav}/></h2>
    <ul className='section'>
        <p>Main</p>
        <li id='active'><BsBrowserEdge className='left-icons'/><a href=''>Browse</a></li>
        <li> <AiOutlineHeart className='left-icons'/> <a href=''>WatchList</a></li>
        <li> <MdOutlineBrowseGallery className='left-icons'/> <a href=''>Coming Soon</a>   </li>
    </ul>
    <ul className='section'>
        <p>Social</p>
        <li><AiOutlineCloudDownload className='left-icons'/><a href=''>Downloads</a> </li>
        <li><AiOutlineLike className='left-icons'/><a href=''>Liked Videos</a> </li>
    </ul>
    <ul className='section'>
    <p>General</p>
        <li><AiOutlineSetting className='left-icons'/><a href=''>Settings</a> </li>
        <li><TbLogout className='left-icons'/><a href=''>Logout</a> </li>
    </ul>

    <div id='games'>
        <div className='games-dis'>
            <div id='flexbox'>
                <div id='sl-icon'>
                    <SlGameController id='game-icon'/>
                </div>
                <h3>Interactive Games</h3>
                <p>play interactive games</p>
                <button><h5>View Games</h5></button>
            </div>
        </div>
    </div>
    </div>
}
export default LeftNavDis;