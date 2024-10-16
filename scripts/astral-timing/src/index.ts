#!/usr/bin/env ts-node

import Geocoder from 'node-geocoder';
import { getDaySections } from './utils/astro';

import { readSourceDir } from './utils/read';
import { XMLDesktopWallpaper, generateWallpaperRecord } from './utils/xmlr';
import { writeFileSync } from 'fs';

const transition = 0;
const base = '/home/mason/Pictures/Dynamic Wallpapers'
const dir = 'Pixel_Landscape_sections'

async function main() {

    const geoCoder = Geocoder({provider: 'openstreetmap'})

    const goecoderResponse = await geoCoder.geocode('Lacey, WA');

    if (goecoderResponse.length === 0) {
        console.error('No results found');
        process.exit(1);
    }

    const { latitude, longitude } = goecoderResponse[0];

    if (latitude === undefined || longitude === undefined) {
        console.error('No latitude or longitude found');
        process.exit(1);
    }

    const daySections = await getDaySections({ lat: latitude, lon: longitude, elevation: 62 });

    daySections.list().forEach((section) => {
        console.log(`${section.key}: ${section.time.getDate().toLocaleString()}`);
    });
 
    const xml = new XMLDesktopWallpaper(); 

    const dirTree = readSourceDir(`${base}/${dir}`);


    // seconds
    let totalDuration = 0;

    let first = true;
    daySections.list().forEach((section) => {
        const dir = dirTree.lookup(...section.key.split('.'));
        if (dir === null) {
            throw new Error(`Directory not found: ${section.key}`);
        }
        if (dir.files === undefined) {
            throw new Error(`No files found in directory: ${section.key}`);
        }

        let dur = daySections.getDuration(section.key);
        if (dur === 0) {
            throw new Error(`Duration is 0: ${section.key}`);
        } else if (dur === -1) {
            // last item should add up to 24 hours
            dur = (24 * 60 * 60) - totalDuration;
        }

        let fileDuration = Math.floor(dur / dir.files.length);

        if (transition) {
            fileDuration -= transition
        }

        for (const file of dir.files) {
            if (first) {
                xml.addStartTime(section.time.getDate());
            }
            xml.addImage(file, fileDuration, first ? undefined : transition);
            totalDuration = totalDuration + fileDuration + (first ? 0 : transition);
            first = false;
        }
    });

    writeFileSync(`${base}/${dir}/index.xml`, xml.toString(), 'utf8');

    writeFileSync(
        `/home/mason/.local/share/gnome-background-properties/${dir}.xml`, 
        generateWallpaperRecord(`${base}/${dir}/index.xml`), 
        'utf8'
    );

    console.log(`Total duration: ${totalDuration / 60 / 60} hours`);
}
main()