import React from "react";
import {
    ComposableMap,
    Geographies,
    Geography,
    Marker
} from "react-simple-maps";
import ethiopiaGeo from "../assets/ethiopia.json";

const EthiopiaMap = () => {
    // Mock markers for sessions in Ethiopia (Addis Ababa, Dire Dawa, Bahir Dar)
    const markers = [
        { name: "Addis Ababa", coordinates: [38.74, 9.03] },
        { name: "Dire Dawa", coordinates: [41.86, 9.59] },
        { name: "Bahir Dar", coordinates: [37.38, 11.59] },
    ];

    return (
        <div style={{ width: "100%", height: "240px", overflow: "hidden" }}>
            <ComposableMap
                projection="geoMercator"
                projectionConfig={{
                    scale: 2200,
                    center: [39, 9]
                }}
                style={{ width: "100%", height: "100%" }}
            >
                <Geographies geography={ethiopiaGeo}>
                    {({ geographies }) =>
                        geographies.map((geo) => (
                            <Geography
                                key={geo.rsmKey}
                                geography={geo}
                                fill="var(--surface-hover)"
                                stroke="var(--divider)"
                                strokeWidth={0.5}
                                style={{
                                    default: { outline: "none" },
                                    hover: { fill: "var(--primary-glow)", outline: "none" },
                                    pressed: { outline: "none" },
                                }}
                            />
                        ))
                    }
                </Geographies>
                {markers.map(({ name, coordinates }) => (
                    <Marker key={name} coordinates={coordinates}>
                        <circle r={4} fill="var(--primary)" stroke="var(--background)" strokeWidth={1} />
                        <circle r={8} fill="var(--primary)" opacity={0.2}>
                            <animate attributeName="r" from="4" to="12" dur="2s" begin="0s" repeatCount="indefinite" />
                            <animate attributeName="opacity" from="0.4" to="0" dur="2s" begin="0s" repeatCount="indefinite" />
                        </circle>
                    </Marker>
                ))}
            </ComposableMap>
        </div>
    );
};

export default EthiopiaMap;
